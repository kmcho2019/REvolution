module TopModule(
    input  in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

reg [1:0] ns_A, ns_B, ns_C, ns_D;

always @(*) begin
    // Determine next state
    ns_A = in ? 2'b01 : 2'b00; // State A
    ns_B = in ? 2'b01 : 2'b10; // State B
    ns_C = in ? 2'b11 : 2'b00; // State C
    ns_D = in ? 2'b01 : 2'b10; // State D

    // Use multiplexer to select next state
    case(state)
        2'b00: next_state = ns_A;
        2'b01: next_state = ns_B;
        2'b10: next_state = ns_C;
        2'b11: next_state = ns_D;
        default: next_state = 2'b00; // Default state
    endcase

    // Determine output
    case(state)
        2'b11: out = 1'b1; // Output is 1 only in state D
        default: out = 1'b0;
    endcase
end

endmodule