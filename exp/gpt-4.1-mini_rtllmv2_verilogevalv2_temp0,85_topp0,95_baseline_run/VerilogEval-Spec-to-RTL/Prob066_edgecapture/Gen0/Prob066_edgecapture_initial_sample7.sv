module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] in_reg;

    always @(posedge clk) begin
        if (reset) begin
            in_reg <= 32'b0;
            out <= 32'b0;
        end else begin
            // Detect 1->0 transition: previous bit 1 and current bit 0
            out <= out | (in_reg & ~in);
            in_reg <= in;
        end
    end

endmodule