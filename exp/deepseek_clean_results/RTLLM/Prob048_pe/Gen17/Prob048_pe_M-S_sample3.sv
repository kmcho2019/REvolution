module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Sequential accumulation with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'b0;  // Clear on reset
        end else begin
            // Direct 32-bit multiply and accumulate
            c <= c + (a * b);
        end
    end

endmodule