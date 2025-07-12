module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= 32'b0;
        end else begin
            // Update output: set bits where we detect falling edge, or keep previously set bits
            out <= out | (prev_in & ~in);
            // Store current input for next cycle
            prev_in <= in;
        end
    end

endmodule