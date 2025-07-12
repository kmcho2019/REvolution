module TopModule(
    input [99:0] a,  // 100-bit input
    input [99:0] b,  // 100-bit input
    input sel,      // select line
    output [99:0] out  // 100-bit output
);

    always @(a, b, sel) begin
        if (sel == 1'b0)
            out = a;
        else
            out = b;
    end

endmodule