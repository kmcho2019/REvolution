module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

always_comb begin
    case (state)
        4'b0001: // State A
            begin
                if (!in) next_state = 4'b0001; // Next state is A if in=0
                else next_state = 4'b0010; // Next state is B if in=1
                out = 1'b0; // Output is 0
            end
        4'b0010: // State B
            begin
                if (!in) next_state = 4'b0100; // Next state is C if in=0
                else next_state = 4'b0010; // Next state is B if in=1
                out = 1'b0; // Output is 0
            end
        4'b0100: // State C
            begin
                if (!in) next_state = 4'b0001; // Next state is A if in=0
                else next_state = 4'b1000; // Next state is D if in=1
                out = 1'b0; // Output is 0
            end
        4'b1000: // State D
            begin
                if (!in) next_state = 4'b0100; // Next state is C if in=0
                else next_state = 4'b0010; // Next state is B if in=1
                out = 1'b1; // Output is 1
            end
        default: // If state is not recognized
            begin
                next_state = 4'b0000; // Invalid state, set next state to 0
                out = 1'b0; // Output is 0
            end
    endcase
end

endmodule