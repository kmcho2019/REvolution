module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] state;
reg [3:0] next_state;

assign next_state = (reset || state == 4'd9) ? 4'd0 : state + 4'd1;

always @(posedge clk) begin
    state <= next_state;
end

assign q = state;

endmodule