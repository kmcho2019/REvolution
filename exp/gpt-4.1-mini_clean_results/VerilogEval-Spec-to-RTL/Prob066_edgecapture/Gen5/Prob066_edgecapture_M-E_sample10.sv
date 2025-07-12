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
            // Detect falling edges: previous bit was 1, current bit is 0
            out <= out | (prev_in & ~in);

            // Update previous input for next cycle
            prev_in <= in;
        end
    end

endmodule