module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

    always @(*) begin
        case (state)
            4'b0001: begin // State A
                if (!in) 
                    next_state = 4'b0001; // Stay in A if in=0
                else 
                    next_state = 4'b0010; // Move to B if in=1
                out = 1'b0; // Output is 0 in state A
            end
            4'b0010: begin // State B
                if (!in) 
                    next_state = 4'b0100; // Move to C if in=0
                else 
                    next_state = 4'b0010; // Stay in B if in=1
                out = 1'b0; // Output is 0 in state B
            end
            4'b0100: begin // State C
                if (!in) 
                    next_state = 4'b0001; // Move to A if in=0
                else 
                    next_state = 4'b1000; // Move to D if in=1
                out = 1'b0; // Output is 0 in state C
            end
            4'b1000: begin // State D
                if (!in) 
                    next_state = 4'b0100; // Move to C if in=0
                else 
                    next_state = 4'b0010; // Move to B if in=1
                out = 1'b1; // Output is 1 in state D
            end
            default: begin // Invalid state
                next_state = 4'b0001; // Move to A if in an invalid state
                out = 1'b0; // Output is 0 for invalid states
            end
        endcase
    end

endmodule