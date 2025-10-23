module TopModule(
    input clk,
    input d,
    output reg q = 0
);

reg mid_q = 0; // Intermediate stage to hold captured value

always @(posedge clk) begin
    mid_q <= d; // Capture input d on positive edge of clk
end

always @(posedge clk) begin
    q <= mid_q; // Transfer captured value to output q on next positive edge
end

endmodule