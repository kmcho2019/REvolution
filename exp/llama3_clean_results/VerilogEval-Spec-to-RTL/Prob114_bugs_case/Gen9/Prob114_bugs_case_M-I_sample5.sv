module TopModule(
    input  [7:0] code,
    output [3:0] out,
    output       valid
);

    assign {valid, out} = (
        (code == 8'h45) ? 5'h10 :
        (code == 8'h16) ? 5'h11 :
        (code == 8'h1e) ? 5'h12 :
        (code == 8'h26) ? 5'h13 :
        (code == 8'h25) ? 5'h14 :
        (code == 8'h2e) ? 5'h15 :
        (code == 8'h36) ? 5'h16 :
        (code == 8'h3d) ? 5'h17 :
        (code == 8'h3e) ? 5'h18 :
        (code == 8'h46) ? 5'h19 :
        5'h0
    );

endmodule