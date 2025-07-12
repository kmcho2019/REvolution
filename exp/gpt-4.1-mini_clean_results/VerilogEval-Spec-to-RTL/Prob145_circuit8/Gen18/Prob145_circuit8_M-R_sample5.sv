module TopModule(
    input  clock,
    input  a,
    output p,
    output q
);

reg [1:0] state; // state[1] = p, state[0] = q

always @(posedge clock) begin
    state[1] <= a & state[0]; // p <= a & q
    state[0] <= state[1];     // q <= p
end

assign p = state[1];
assign q = state[0];

endmodule