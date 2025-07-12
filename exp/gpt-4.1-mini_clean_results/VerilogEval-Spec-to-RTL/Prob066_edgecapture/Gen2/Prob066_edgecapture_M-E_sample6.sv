module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out <= 32'b0;
        end else begin
            prev_in <= in;
            // Detect falling edge: bit was 1 in prev_in and is now 0 in in
            // Once a bit in out is set, it remains until reset
            out <= out | (prev_in & ~in);
        end
    end

endmodule