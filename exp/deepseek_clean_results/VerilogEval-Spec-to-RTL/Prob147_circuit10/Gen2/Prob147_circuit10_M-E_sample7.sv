module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg seen_a = 0;

always @(posedge clk) begin
    if (~a & ~b) begin
        seen_a <= 0;  // Reset condition
    end else if (a) begin
        seen_a <= 1;   // Mark that we've seen a 1
    end
end

assign q = (b & seen_a) | (a & ~seen_a);
assign state = seen_a;

endmodule