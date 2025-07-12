module TopModule (
    input  clk,
    input  d,
    output reg q
);

    reg clk_dly;  // delayed version of clk
    wire clk_xor; // internal clock toggling on both edges of clk

    // Delay clk by one clk cycle to generate clk_dly
    always @(posedge clk) begin
        clk_dly <= clk;
    end

    // XOR clk and delayed clk to create clk_xor that toggles at both edges of clk
    assign clk_xor = clk ^ clk_dly;

    // Positive-edge triggered flip-flop clocked by clk_xor to capture d on both edges of clk
    always @(posedge clk_xor) begin
        q <= d;
    end

endmodule