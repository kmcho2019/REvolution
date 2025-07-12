module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg [1:0] state;
wire [1:0] next_state;

assign next_state[0] = state[1];        // q <= previous p
assign next_state[1] = state[1] | a;    // p <= p | a

always @(posedge clock) begin
    state <= next_state;
end

assign p = state[1];
assign q = state[0];

initial begin
    state = 2'b00;
end

endmodule