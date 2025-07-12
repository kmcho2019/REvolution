module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire [2:0] next_q;
wire counter_wrap = (q == 3'd6);
wire [2:0] incremented = q + 1'b1;
wire [2:0] next_counter = counter_wrap ? 3'd0 : incremented;

assign next_q = a ? 3'd4 : next_counter;

always @(posedge clk) begin
    q <= next_q;
end

endmodule