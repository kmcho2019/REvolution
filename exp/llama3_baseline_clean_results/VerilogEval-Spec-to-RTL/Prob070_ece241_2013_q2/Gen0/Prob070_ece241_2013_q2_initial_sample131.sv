module TopModule(a, b, c, d, out_sop, out_pos);
    input a, b, c, d;
    output out_sop, out_pos;

    assign out_sop = (~a & ~b & c) | (~a & b & c & d) | (a & b & ~c & ~d) | (a & b & c & d);
    assign out_pos = ~( (~a & ~b & ~c & ~d) | (~a & ~b & ~c & d) | (~a & ~b & c & ~d) | (~a & ~b & c & d) | (~a & b & ~c & ~d) | (~a & b & ~c & d) | (~a & b & c & ~d) | (a & ~b & ~c & ~d) | (a & ~b & c & ~d) );
endmodule