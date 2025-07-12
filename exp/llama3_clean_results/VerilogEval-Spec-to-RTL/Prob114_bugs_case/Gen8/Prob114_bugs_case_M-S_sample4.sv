module TopModule(
    input  [7:0] code,
    output [3:0] out,
    output       valid
);

    assign {valid, out} = (
        (code == 8'h45) ? 5'h0  :
        (code == 8'h16) ? 5'h1  :
        (code == 8'h1e) ? 5'h2  :
        (code == 8'h26) ? 5'h3  :
        (code == 8'h25) ? 5'h4  :
        (code == 8'h2e) ? 5'h5  :
        (code == 8'h36) ? 5'h6  :
        (code == 8'h3d) ? 5'h7  :
        (code == 8'h3e) ? 5'h8  :
        (code == 8'h46) ? 5'h9  :
        5'h0
    );

endmodule