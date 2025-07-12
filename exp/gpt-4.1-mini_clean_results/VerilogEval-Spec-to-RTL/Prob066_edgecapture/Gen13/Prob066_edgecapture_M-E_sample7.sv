module TopModule (
    input         clk,
    input         reset,
    input  [31:0] in,
    output reg [31:0] out
);

    reg [31:0] delay_reg;

    always @(posedge clk) begin
        if (reset) begin
            delay_reg <= 32'b0;
            out <= 32'b0;
        end else begin
            // Detect falling edges: bits that were 1 in delay_reg and 0 now
            out <= out | (delay_reg & ~in);
            // Update delayed input register with current input
            delay_reg <= in;
        end
    end

endmodule