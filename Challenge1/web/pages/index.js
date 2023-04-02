import Head from 'next/head';
import Layout, { siteTitle } from '../components/layout';
import utilStyles from '../styles/utils.module.css';

export default function Home() {
  return (
    <Layout home>
      <Head>
        <title>{siteTitle}</title>
      </Head>
      <section className={utilStyles.headingMd}>
        <p>wow isn't NGINX fun? 😔</p>
        <p>
          <a href="/api/getData">🤫 super secret database here 🤫</a>
        </p>
      </section>
    </Layout>
  );
}