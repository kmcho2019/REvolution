module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Signed multiply-accumulate with synchronous reset
    always @(posedge clk) begin
        if (rst) c <= 32'sd0;       // Synchronous reset
        else     c <= c + a * b;     // Signed multiply-accumulate
    end

endmodule