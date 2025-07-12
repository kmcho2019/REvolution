module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// Combinational next state logic
wire [2:0] next_q;
wire incremented;

assign incremented = (q == 3'd6) ? 1'b0 : 1'b1;
assign next_q = a ? 3'd4 : (incremented ? q + 3'd1 : 3'd0);

always @(posedge clk) begin
    q <= next_q;
end

endmodule