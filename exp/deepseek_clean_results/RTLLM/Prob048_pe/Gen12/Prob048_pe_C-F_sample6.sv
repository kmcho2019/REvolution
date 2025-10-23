module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Full precision multiplication result
    wire signed [63:0] product = a * b;

    // Registered accumulation with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'sd0;  // Signed zero clear
        end else begin
            c <= c + product[31:0];  // Truncated accumulation
        end
    end

endmodule