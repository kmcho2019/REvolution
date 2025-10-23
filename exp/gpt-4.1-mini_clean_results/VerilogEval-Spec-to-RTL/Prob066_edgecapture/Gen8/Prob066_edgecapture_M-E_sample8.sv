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
            // Detect falling edges: bits that were 1 in prev_in and now 0 in in
            wire [31:0] falling_edges = prev_in & (~in);
            // Latch falling edges into out (hold until reset)
            out <= out | falling_edges;
            prev_in <= in;
        end
    end

endmodule