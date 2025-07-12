module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] in_reg;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            in_reg <= 32'b0;
        end
        else begin
            out <= out | (in_reg & ~in);  // Detect and latch falling edges
            in_reg <= in;                 // Store current input for next cycle
        end
    end

endmodule