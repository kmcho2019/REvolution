module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

    always @(*) begin
        case(state)
            2'b00: // State A
                begin
                    if (!in) begin
                        next_state = 2'b00; // Stay in A if in=0
                    end else begin
                        next_state = 2'b01; // Go to B if in=1
                    end
                    out = 0; // Output 0 in state A
                end
            2'b01: // State B
                begin
                    next_state = in ? 2'b01 : 2'b10; // Stay in B if in=1, go to C if in=0
                    out = 0; // Output 0 in state B
                end
            2'b10: // State C
                begin
                    next_state = in ? 2'b11 : 2'b00; // Go to D if in=1, go to A if in=0
                    out = 0; // Output 0 in state C
                end
            2'b11: // State D
                begin
                    next_state = in ? 2'b01 : 2'b10; // Go to B if in=1, go to C if in=0
                    out = 1; // Output 1 in state D
                end
            default: 
                next_state = 2'b00; // Default next state
                out = 0; // Default output
        endcase
    end

endmodule