module TopModule(
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

    always @(*) begin
        case(state)
            2'b00: // State A
                begin
                    if (!in) 
                        next_state = 2'b00; // Next state A when in=0
                    else 
                        next_state = 2'b01; // Next state B when in=1
                    out = 1'b0;
                end
            2'b01: // State B
                begin
                    if (!in) 
                        next_state = 2'b10; // Next state C when in=0
                    else 
                        next_state = 2'b01; // Next state B when in=1
                    out = 1'b0;
                end
            2'b10: // State C
                begin
                    if (!in) 
                        next_state = 2'b00; // Next state A when in=0
                    else 
                        next_state = 2'b11; // Next state D when in=1
                    out = 1'b0;
                end
            2'b11: // State D
                begin
                    if (!in) 
                        next_state = 2'b10; // Next state C when in=0
                    else 
                        next_state = 2'b01; // Next state B when in=1
                    out = 1'b1;
                end
            default:
                next_state = 2'b00; // Default to state A if state is invalid
                out = 1'b0;
        endcase
    end

endmodule