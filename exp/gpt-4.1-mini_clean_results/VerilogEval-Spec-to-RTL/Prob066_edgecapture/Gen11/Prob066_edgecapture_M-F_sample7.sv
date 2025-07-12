module TopModule (
    input              clk,
    input              reset,
    input      [31:0]  in,
    output reg [31:0]  out
);

    reg [31:0] prev_in;
    reg [31:0] falling_edges;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out <= 32'b0;
        end else begin
            falling_edges = prev_in & ~in;  // detect falling edges
            out <= out | falling_edges;     // latch falling edges
            prev_in <= in;                  // update previous input
        end
    end

endmodule