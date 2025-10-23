module TopModule(
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

always @(state, in) begin
    case(state)
        2'b00: // State A
            if(!in) next_state = 2'b00; // in=0, stay in A
            else next_state = 2'b01; // in=1, go to B
        2'b01: // State B
            if(!in) next_state = 2'b10; // in=0, go to C
            else next_state = 2'b01; // in=1, stay in B
        2'b10: // State C
            if(!in) next_state = 2'b00; // in=0, go to A
            else next_state = 2'b11; // in=1, go to D
        2'b11: // State D
            if(!in) next_state = 2'b10; // in=0, go to C
            else next_state = 2'b01; // in=1, go to B
    endcase

    case(state)
        2'b00, 2'b01, 2'b10: out = 1'b0; // Output is 0 for states A, B, C
        2'b11: out = 1'b1; // Output is 1 for state D
    endcase
end

endmodule