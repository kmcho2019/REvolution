module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] state = 4'b0;
wire [3:0] next_state;

assign next_state = (shift_ena) ? {data, state[3:1]} : 
                   (count_ena) ? (state == 4'b0) ? 4'b1111 : state - 1 : state;

always @(posedge clk) begin
    state <= next_state;
end

assign q = state;

endmodule