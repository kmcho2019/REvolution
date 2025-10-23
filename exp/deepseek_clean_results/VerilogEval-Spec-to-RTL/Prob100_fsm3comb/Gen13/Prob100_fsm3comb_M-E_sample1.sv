module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

// LUT format: {next_if_1, next_if_0, output}
reg [5:0] state_lut [0:3];

initial begin
    // State A: next1=B(01), next0=A(00), out=0
    state_lut[2'b00] = {2'b01, 2'b00, 1'b0};
    // State B: next1=B(01), next0=C(10), out=0
    state_lut[2'b01] = {2'b01, 2'b10, 1'b0};
    // State C: next1=D(11), next0=A(00), out=0
    state_lut[2'b10] = {2'b11, 2'b00, 1'b0};
    // State D: next1=B(01), next0=C(10), out=1
    state_lut[2'b11] = {2'b01, 2'b10, 1'b1};
end

always @(*) begin
    // Select next state based on input
    next_state = in ? state_lut[state][5:4] : state_lut[state][3:2];
    // Output is constant for each state
    out = state_lut[state][0];
end

endmodule