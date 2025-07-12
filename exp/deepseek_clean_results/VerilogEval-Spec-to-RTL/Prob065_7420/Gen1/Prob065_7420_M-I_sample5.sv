module TopModule (
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

    // Input buffers for better signal integrity
    wire p1a_buf, p1b_buf, p1c_buf, p1d_buf;
    wire p2a_buf, p2b_buf, p2c_buf, p2d_buf;
    
    buf b1(p1a_buf, p1a);
    buf b2(p1b_buf, p1b);
    buf b3(p1c_buf, p1c);
    buf b4(p1d_buf, p1d);
    buf b5(p2a_buf, p2a);
    buf b6(p2b_buf, p2b);
    buf b7(p2c_buf, p2c);
    buf b8(p2d_buf, p2d);

    // Balanced implementation of 4-input NAND using 2-input NANDs
    wire p1_ab, p1_cd;
    wire p2_ab, p2_cd;
    
    nand n1(p1_ab, p1a_buf, p1b_buf);
    nand n2(p1_cd, p1c_buf, p1d_buf);
    nor  n3(p1y, p1_ab, p1_cd);
    
    nand n4(p2_ab, p2a_buf, p2b_buf);
    nand n5(p2_cd, p2c_buf, p2d_buf);
    nor  n6(p2y, p2_ab, p2_cd);

endmodule