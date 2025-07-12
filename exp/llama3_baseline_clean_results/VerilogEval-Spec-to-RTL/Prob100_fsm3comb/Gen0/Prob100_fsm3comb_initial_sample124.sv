module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

always @(state or in) begin
    case(state)
        2'b00: // State A
            if (!in) 
                next_state = 2'b00; // Next state is A when in is 0
            else 
                next_state = 2'b01; // Next state is B when in is 1
        2'b01: // State B
            if (!in) 
                next_state = 2'b10; // Next state is C when in is 0
            else 
                next_state = 2'b01; // Next state is B when in is 1
        2'b10: // State C
            if (!in) 
                next_state = 2'b00; // Next state is A when in is 0
            else 
                next_state = 2'b11; // Next state is D when in is 1
        2'b11: // State D
            if (!in) 
                next_state = 2'b10; // Next state is C when in is 0
            else 
                next_state = 2'b01; // Next state is B when in is 1
    endcase
    
    case(state)
        2'b00, 2'b01, 2'b10: out = 1'b0; // Output is 0 for states A, B, C
        2'b11: out = 1'b1; // Output is 1 for state D
    endcase
end

endmodule