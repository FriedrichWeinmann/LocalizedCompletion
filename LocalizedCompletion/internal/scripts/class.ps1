$code = @'
using System;
using System.Collections;

namespace LocalizedCompletion
{
	public class Selector
	{
		public string Language;
		public string DefaultLanguage;

		public Selector(string Language, string DefaultLanguage)
		{
			this.Language = Language;
			this.DefaultLanguage = DefaultLanguage;
		}

		public string Select(string Original, Hashtable Localization)
		{
			if (null == Localization)
				return Original;
			if (null != Localization[Language] && !String.IsNullOrEmpty(Localization[Language].ToString()))
				return Localization[Language].ToString();
			if (null != Localization[DefaultLanguage] && !String.IsNullOrEmpty(Localization[DefaultLanguage].ToString()))
				return Localization[DefaultLanguage].ToString();

			return Original;
		}

		public string SelectParameter(string Original, Hashtable Localization)
		{
			if (null == Localization)
				return Original;
			if (null != Localization[Language] && !String.IsNullOrEmpty(Localization[Language].ToString()))
				return $"-{Localization[Language].ToString().TrimStart('-')}";
			if (null != Localization[DefaultLanguage] && !String.IsNullOrEmpty(Localization[DefaultLanguage].ToString()))
				return $"-{Localization[DefaultLanguage].ToString().TrimStart('-')}";

			return Original;
		}
	}
}
'@
try { Add-Type $code -ErrorAction Ignore }
catch { }