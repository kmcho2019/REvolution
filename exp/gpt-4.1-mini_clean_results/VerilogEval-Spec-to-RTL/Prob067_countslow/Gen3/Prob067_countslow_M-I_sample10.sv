module TopModule(
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

wire [3:0] q_next;
wire wrap;

// Compute next value and wrap signal without a comparator:
assign wrap = (q == 4'd9);
assign q_next = wrap ? 4'd0 : (q + 4'd1);

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else if (slowena)
        q <= q_next;
end

endmodule