module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    always @(*) begin
        case(state)
            4'b0001: // State A
                begin
                    if(!in) next_state = 4'b0001; // Next state A when in=0
                    else next_state = 4'b0010; // Next state B when in=1
                    out = 1'b0; // Output 0 for state A
                end
            4'b0010: // State B
                begin
                    if(!in) next_state = 4'b0100; // Next state C when in=0
                    else next_state = 4'b0010; // Next state B when in=1
                    out = 1'b0; // Output 0 for state B
                end
            4'b0100: // State C
                begin
                    if(!in) next_state = 4'b0001; // Next state A when in=0
                    else next_state = 4'b1000; // Next state D when in=1
                    out = 1'b0; // Output 0 for state C
                end
            4'b1000: // State D
                begin
                    if(!in) next_state = 4'b0100; // Next state C when in=0
                    else next_state = 4'b0010; // Next state B when in=1
                    out = 1'b1; // Output 1 for state D
                end
            default: 
                begin
                    next_state = 4'b0000; // Default next state
                    out = 1'b0; // Default output
                end
        endcase
    end

endmodule