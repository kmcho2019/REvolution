// The original code provided is already quite optimized for the task.
// However, to further optimize, we can consider using the same logic but
// ensure that it's correctly structured and utilize any applicable optimizations.

module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 4'd0;
    end else if (state == 4'd9) begin
        state <= 4'd0;
    end else begin
        state <= state + 1;
    end
end

assign q = state;

endmodule