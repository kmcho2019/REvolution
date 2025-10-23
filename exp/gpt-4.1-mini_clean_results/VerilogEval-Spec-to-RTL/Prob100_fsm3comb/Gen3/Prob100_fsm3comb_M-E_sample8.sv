module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

// Define the next state lookup table:
// index = {state, in} = 3 bits, arranged as {state[1], state[0], in}
// States: A=00, B=01, C=10, D=11
// For each state and input, assign the next state per specification
// Encoding 3-bit address: MSB state[1], middle state[0], LSB in
// address:  state  in
//   0: 000 -> A(00)
//   1: 001 -> B(01)
//   2: 010 -> C(10)
//   3: 011 -> B(01)
//   4: 100 -> A(00)
//   5: 101 -> D(11)
//   6: 110 -> C(10)
//   7: 111 -> B(01)

wire [2:0] addr = {state, in};
reg  [1:0] next_state_reg;
reg        out_reg;

always @(*) begin
    case (addr)
        3'b000: next_state_reg = 2'b00; // A->A with in=0
        3'b001: next_state_reg = 2'b01; // A->B with in=1
        3'b010: next_state_reg = 2'b10; // B->C with in=0
        3'b011: next_state_reg = 2'b01; // B->B with in=1
        3'b100: next_state_reg = 2'b00; // C->A with in=0
        3'b101: next_state_reg = 2'b11; // C->D with in=1
        3'b110: next_state_reg = 2'b10; // D->C with in=0
        3'b111: next_state_reg = 2'b01; // D->B with in=1
        default: next_state_reg = 2'b00;
    endcase

    // Output depends only on current state (Moore machine)
    case (state)
        2'b11: out_reg = 1'b1; // D outputs 1
        default: out_reg = 1'b0; // All other states output 0
    endcase
end

assign next_state = next_state_reg;
assign out = out_reg;

endmodule