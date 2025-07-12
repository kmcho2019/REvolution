module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg [1:0] state; // state[1] = q, state[0] = p

always @(posedge clock) begin
    state <= {state[0], a | state[1]};
end

assign p = state[0];
assign q = state[1];

endmodule