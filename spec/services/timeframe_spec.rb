describe Timeframe do
  subject(:decoder) do
    described_class.new(
      string,
      min_date: Date.new(2019, 5, 2),
      allowed_days_in_future: 1,
    )
  end

  before { travel_to Time.zone.local(2022, 10, 13, 10, 0, 0) }

  describe 'static methods' do
    describe '.now' do
      subject { described_class.now }

      it { is_expected.to be_now }
    end

    describe '.all' do
      subject { described_class.all }

      it { is_expected.to be_all }
    end

    describe '.regex' do
      subject { described_class.regex }

      it { is_expected.to match('2022-02-02') }
      it { is_expected.to match('2022-W42') }
      it { is_expected.to match('2022-02') }
      it { is_expected.to match('2022') }
      it { is_expected.to match('all') }
      it { is_expected.to match('now') }

      it { is_expected.not_to match('foo') }
      it { is_expected.not_to match('42') }
    end
  end

  context 'when string is "now"' do
    let(:string) { 'now' }

    it 'returns the correct id' do
      expect(decoder.id).to eq(:now)
    end

    it 'returns the correct to_s' do
      expect(decoder.to_s).to eq(string)
    end

    it 'returns the correct beginning' do
      expect(decoder.beginning).to eq('2022-10-13 10:00:00 +0200')
    end

    it 'returns the correct ending' do
      expect(decoder.ending).to eq('2022-10-13 10:00:00 +0200')
    end

    it 'returns the correct next timeframe' do
      expect(decoder.next).to be_nil
    end

    it 'returns the correct previous timeframe' do
      expect(decoder.prev).to be_nil
    end

    it 'returns the correct localized' do
      expect(decoder.localized).to eq('Today, 10:00')
    end

    it 'returns the correct corresponding_day' do
      expect(decoder.corresponding_day).to eq('2022-10-13')
    end

    it 'returns the correct corresponding_week' do
      expect(decoder.corresponding_week).to eq('2022-W41')
    end

    it 'returns the correct corresponding_month' do
      expect(decoder.corresponding_month).to eq('2022-10')
    end

    it 'returns the correct corresponding_year' do
      expect(decoder.corresponding_year).to eq('2022')
    end

    it 'returns the correct inquirer' do
      expect(decoder.now?).to be(true)
      expect(decoder.day?).to be(false)
      expect(decoder.week?).to be(false)
      expect(decoder.month?).to be(false)
      expect(decoder.year?).to be(false)
      expect(decoder.all?).to be(false)
    end

    it 'is not out_of_range' do
      expect(decoder.out_of_range?).to be(false)
    end

    it 'is current' do
      expect(decoder.current?).to be(true)
    end

    it 'is not past' do
      expect(decoder.past?).to be(false)
    end

    it 'is not future' do
      expect(decoder.future?).to be(false)
    end
  end

  context 'when string is a day in the past' do
    let(:string) { '2022-05-13' }

    it 'returns the correct id' do
      expect(decoder.id).to eq(:day)
    end

    it 'returns the correct to_s' do
      expect(decoder.to_s).to eq(string)
    end

    it 'returns the correct beginning' do
      expect(decoder.beginning).to eq('2022-05-13 00:00:00.000000000 +0200')
    end

    it 'returns the correct ending' do
      expect(decoder.ending).to eq('2022-05-13 23:59:59.999999999 +0200')
    end

    it 'returns the correct next timeframe' do
      expect(decoder.next.to_s).to eq('2022-05-14')
    end

    it 'returns the correct previous timeframe' do
      expect(decoder.prev.to_s).to eq('2022-05-12')
    end

    it 'returns the correct localized' do
      expect(decoder.localized).to eq('Friday, 13. May 2022')
    end

    it 'returns the correct corresponding_day' do
      expect(decoder.corresponding_day).to eq(string)
    end

    it 'returns the correct corresponding_week' do
      expect(decoder.corresponding_week).to eq('2022-W19')
    end

    it 'returns the correct corresponding_month' do
      expect(decoder.corresponding_month).to eq('2022-05')
    end

    it 'returns the correct corresponding_year' do
      expect(decoder.corresponding_year).to eq('2022')
    end

    it 'returns the correct inquirer' do
      expect(decoder.now?).to be(false)
      expect(decoder.day?).to be(true)
      expect(decoder.week?).to be(false)
      expect(decoder.month?).to be(false)
      expect(decoder.year?).to be(false)
      expect(decoder.all?).to be(false)
    end

    it 'is not out_of_range' do
      expect(decoder.out_of_range?).to be(false)
    end

    it 'is not current' do
      expect(decoder.current?).to be(false)
    end

    it 'is past' do
      expect(decoder.past?).to be(true)
    end

    it 'is not future' do
      expect(decoder.future?).to be(false)
    end
  end

  context 'when string is a day in the future' do
    let(:string) { '2022-10-14' }

    it 'is not current' do
      expect(decoder.current?).to be(false)
    end

    it 'is not past' do
      expect(decoder.past?).to be(false)
    end

    it 'is future' do
      expect(decoder.future?).to be(true)
    end
  end

  context 'when string is first day of the year' do
    let(:string) { '2022-01-01' }

    it 'returns the corresponding_week with week-based year' do
      expect(decoder.corresponding_week).to eq('2021-W52')
    end
  end

  context 'when string is today' do
    let(:string) { '2022-10-13' }

    it 'is current' do
      expect(decoder.current?).to be(true)
    end

    it 'is not past' do
      expect(decoder.past?).to be(false)
    end

    it 'is not future' do
      expect(decoder.future?).to be(false)
    end
  end

  context 'when string is a week in the past' do
    let(:string) { '2022-W19' }

    it 'returns the correct id' do
      expect(decoder.id).to eq(:week)
    end

    it 'returns the correct to_s' do
      expect(decoder.to_s).to eq(string)
    end

    it 'returns the correct beginning' do
      expect(decoder.beginning).to eq('2022-05-09 00:00:00.000000000 +0200')
    end

    it 'returns the correct ending' do
      expect(decoder.ending).to eq('2022-05-15 23:59:59.999999999 +0200')
    end

    it 'returns the correct next timeframe' do
      expect(decoder.next.to_s).to eq('2022-W20')
    end

    it 'returns the correct previous timeframe' do
      expect(decoder.prev.to_s).to eq('2022-W18')
    end

    it 'returns the correct localized' do
      expect(decoder.localized).to eq('CW 19, 2022')
    end

    it 'returns the correct corresponding_day' do
      expect(decoder.corresponding_day).to eq('2022-05-15')
    end

    it 'returns the correct corresponding_week' do
      expect(decoder.corresponding_week).to eq(string)
    end

    it 'returns the correct corresponding_month' do
      expect(decoder.corresponding_month).to eq('2022-05')
    end

    it 'returns the correct corresponding_year' do
      expect(decoder.corresponding_year).to eq('2022')
    end

    it 'returns the correct inquirer' do
      expect(decoder.now?).to be(false)
      expect(decoder.day?).to be(false)
      expect(decoder.week?).to be(true)
      expect(decoder.month?).to be(false)
      expect(decoder.year?).to be(false)
      expect(decoder.all?).to be(false)
    end

    it 'is not out_of_range' do
      expect(decoder.out_of_range?).to be(false)
    end

    it 'is not current' do
      expect(decoder.current?).to be(false)
    end

    it 'is past' do
      expect(decoder.past?).to be(true)
    end

    it 'is not future' do
      expect(decoder.future?).to be(false)
    end
  end

  context 'when string is a week in the future' do
    let(:string) { '2022-W42' }

    it 'is not current' do
      expect(decoder.current?).to be(false)
    end

    it 'is not past' do
      expect(decoder.past?).to be(false)
    end

    it 'is future' do
      expect(decoder.future?).to be(true)
    end
  end

  context 'when string is current week' do
    let(:string) { '2022-W41' }

    it 'is current' do
      expect(decoder.current?).to be(true)
    end

    it 'is not past' do
      expect(decoder.past?).to be(false)
    end

    it 'is not future' do
      expect(decoder.future?).to be(false)
    end
  end

  context 'when string is a week at end of year' do
    let(:string) { '2020-W50' }

    it 'returns the correct next timeframe' do
      expect(decoder.next.to_s).to eq('2020-W51')
    end

    it 'returns the correct previous timeframe' do
      expect(decoder.prev.to_s).to eq('2020-W49')
    end
  end

  context 'when string is a week at min_date' do
    let(:string) { '2019-W19' }

    it 'returns the correct next timeframe' do
      expect(decoder.next.to_s).to eq('2019-W20')
    end

    it 'returns the correct previous timeframe' do
      expect(decoder.prev.to_s).to eq('2019-W18')
    end
  end

  context 'when string is a month' do
    let(:string) { '2022-05' }

    it 'returns the correct id' do
      expect(decoder.id).to eq(:month)
    end

    it 'returns the correct to_s' do
      expect(decoder.to_s).to eq(string)
    end

    it 'returns the correct beginning' do
      expect(decoder.beginning).to eq('2022-05-01 00:00:00.000000000 +0200')
    end

    it 'returns the correct ending' do
      expect(decoder.ending).to eq('2022-05-31 23:59:59.999999999 +0200')
    end

    it 'returns the correct next timeframe' do
      expect(decoder.next.to_s).to eq('2022-06')
    end

    it 'returns the correct previous timeframe' do
      expect(decoder.prev.to_s).to eq('2022-04')
    end

    it 'returns the correct localized' do
      expect(decoder.localized).to eq('May 2022')
    end

    it 'returns the correct corresponding_day' do
      expect(decoder.corresponding_day).to eq('2022-05-31')
    end

    it 'returns the correct corresponding_week' do
      expect(decoder.corresponding_week).to eq('2022-W22')
    end

    it 'returns the correct corresponding_month' do
      expect(decoder.corresponding_month).to eq(string)
    end

    it 'returns the correct corresponding_year' do
      expect(decoder.corresponding_year).to eq('2022')
    end

    it 'returns the correct inquirer' do
      expect(decoder.now?).to be(false)
      expect(decoder.day?).to be(false)
      expect(decoder.week?).to be(false)
      expect(decoder.month?).to be(true)
      expect(decoder.year?).to be(false)
      expect(decoder.all?).to be(false)
    end

    it 'is not out_of_range' do
      expect(decoder.out_of_range?).to be(false)
    end
  end

  context 'when string is a month at min_date' do
    let(:string) { '2019-06' }

    it 'returns the correct next timeframe' do
      expect(decoder.next.to_s).to eq('2019-07')
    end

    it 'returns the correct previous timeframe' do
      expect(decoder.prev.to_s).to eq('2019-05')
    end

    it 'is not current' do
      expect(decoder.current?).to be(false)
    end

    it 'is past' do
      expect(decoder.past?).to be(true)
    end

    it 'is not future' do
      expect(decoder.future?).to be(false)
    end
  end

  context 'when string is a month in the future' do
    let(:string) { '2022-11' }

    it 'is not current' do
      expect(decoder.current?).to be(false)
    end

    it 'is not past' do
      expect(decoder.past?).to be(false)
    end

    it 'is future' do
      expect(decoder.future?).to be(true)
    end
  end

  context 'when string is current month' do
    let(:string) { '2022-10' }

    it 'is current' do
      expect(decoder.current?).to be(true)
    end

    it 'is not past' do
      expect(decoder.past?).to be(false)
    end

    it 'is not future' do
      expect(decoder.future?).to be(false)
    end
  end

  context 'when string is a year' do
    let(:string) { '2021' }

    it 'returns the correct id' do
      expect(decoder.id).to eq(:year)
    end

    it 'returns the correct to_s' do
      expect(decoder.to_s).to eq(string)
    end

    it 'returns the correct beginning' do
      expect(decoder.beginning).to eq('2021-01-01 00:00:00.000000000 +0100')
    end

    it 'returns the correct ending' do
      expect(decoder.ending).to eq('2021-12-31 23:59:59.999999999 +0100')
    end

    it 'returns the correct next timeframe' do
      expect(decoder.next.to_s).to eq('2022')
    end

    it 'returns the correct previous timeframe' do
      expect(decoder.prev.to_s).to eq('2020')
    end

    it 'returns the correct localized' do
      expect(decoder.localized).to eq('2021')
    end

    it 'returns the correct corresponding_day' do
      expect(decoder.corresponding_day).to eq('2021-12-31')
    end

    it 'returns the correct corresponding_week' do
      expect(decoder.corresponding_week).to eq('2021-W52')
    end

    it 'returns the correct corresponding_month' do
      expect(decoder.corresponding_month).to eq('2021-12')
    end

    it 'returns the correct corresponding_year' do
      expect(decoder.corresponding_year).to eq(string)
    end

    it 'returns the correct inquirer' do
      expect(decoder.now?).to be(false)
      expect(decoder.day?).to be(false)
      expect(decoder.week?).to be(false)
      expect(decoder.month?).to be(false)
      expect(decoder.year?).to be(true)
      expect(decoder.all?).to be(false)
    end

    it 'is not out_of_range' do
      expect(decoder.out_of_range?).to be(false)
    end

    it 'is not current' do
      expect(decoder.current?).to be(false)
    end

    it 'is past' do
      expect(decoder.past?).to be(true)
    end

    it 'is not future' do
      expect(decoder.future?).to be(false)
    end
  end

  context 'when string is future year' do
    let(:string) { '2023' }

    it 'is not current' do
      expect(decoder.current?).to be(false)
    end

    it 'is not past' do
      expect(decoder.past?).to be(false)
    end

    it 'is future' do
      expect(decoder.future?).to be(true)
    end
  end

  context 'when string is current year' do
    let(:string) { '2022' }

    it 'is current' do
      expect(decoder.current?).to be(true)
    end

    it 'is not past' do
      expect(decoder.past?).to be(false)
    end

    it 'is not future' do
      expect(decoder.future?).to be(false)
    end
  end

  context 'when string is a year at min_date' do
    let(:string) { '2020' }

    it 'returns the correct next timeframe' do
      expect(decoder.next.to_s).to eq('2021')
    end

    it 'returns the correct previous timeframe' do
      expect(decoder.prev.to_s).to eq('2019')
    end
  end

  context 'when string is "all"' do
    let(:string) { 'all' }

    it 'returns the correct id' do
      expect(decoder.id).to eq(:all)
    end

    it 'returns the correct to_s' do
      expect(decoder.to_s).to eq(string)
    end

    it 'returns the correct beginning' do
      expect(decoder.beginning).to eq('2019-01-01 00:00:00.000000000 +0100')
    end

    it 'returns the correct ending' do
      expect(decoder.ending).to eq('2022-10-13 23:59:59.999999999 +0200')
    end

    it 'returns the correct next timeframe' do
      expect(decoder.next).to be_nil
    end

    it 'returns the correct previous timeframe' do
      expect(decoder.prev).to be_nil
    end

    it 'returns the correct localized' do
      expect(decoder.localized).to eq(I18n.t('timeframe.all'))
    end

    it 'returns the correct corresponding_day' do
      expect(decoder.corresponding_day).to eq('2022-10-13')
    end

    it 'returns the correct corresponding_week' do
      expect(decoder.corresponding_week).to eq('2022-W41')
    end

    it 'returns the correct corresponding_month' do
      expect(decoder.corresponding_month).to eq('2022-10')
    end

    it 'returns the correct corresponding_year' do
      expect(decoder.corresponding_year).to eq('2022')
    end

    it 'returns the correct inquirer' do
      expect(decoder.now?).to be(false)
      expect(decoder.day?).to be(false)
      expect(decoder.week?).to be(false)
      expect(decoder.month?).to be(false)
      expect(decoder.year?).to be(false)
      expect(decoder.all?).to be(true)
    end

    it 'is not out_of_range' do
      expect(decoder.out_of_range?).to be(false)
    end

    it 'is current' do
      expect(decoder.current?).to be(true)
    end

    it 'is not past' do
      expect(decoder.past?).to be(false)
    end

    it 'is not future' do
      expect(decoder.future?).to be(false)
    end
  end

  context 'when string is invalid' do
    %w[foo 123 2022-09-99 2022-99-09 2022-99 2022-W99].each do |string|
      context "when given #{string}" do
        let(:string) { string }

        it 'raises an error' do
          expect { decoder.beginning }.to raise_error(ArgumentError)
        end
      end
    end
  end

  context 'when date is after max_date' do
    let(:string) { '2022-10-15' }

    it 'is out_of_range' do
      expect(decoder.out_of_range?).to be(true)
    end
  end

  context 'when week is after max_date' do
    let(:string) { '2022-W42' }

    it 'is out_of_range' do
      expect(decoder.out_of_range?).to be(true)
    end
  end

  context 'when date is before min_date' do
    let(:string) { '2019-05-01' }

    it 'is out_of_range' do
      expect(decoder.out_of_range?).to be(true)
    end
  end
end
