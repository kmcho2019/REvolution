module TopModule(
    input [255:0] in, // 256-bit input vector
    input [7:0] sel, // 8-bit select signal
    output reg out // 1-bit output
);

    always @(*) begin
        out = in[sel];
    end

endmodule