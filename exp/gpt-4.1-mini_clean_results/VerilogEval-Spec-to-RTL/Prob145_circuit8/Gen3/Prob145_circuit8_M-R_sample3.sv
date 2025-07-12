module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg [1:0] state; // state[1] = q, state[0] = p

initial begin
    state = 2'b00;
end

always @(posedge clock) begin
    // next state calculation
    // next q = current p
    // next p = a | (p & q)
    state[1] <= state[0];
    state[0] <= a | (state[0] & state[1]);
end

assign p = state[0];
assign q = state[1];

endmodule