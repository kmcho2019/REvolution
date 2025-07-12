module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

always @(*) begin
    case(state)
        2'b00: // State A
            begin
                if(!in)
                    next_state = 2'b00; // Stay in A
                else
                    next_state = 2'b01; // Go to B
                out = 1'b0;
            end
        2'b01: // State B
            begin
                if(!in)
                    next_state = 2'b10; // Go to C
                else
                    next_state = 2'b01; // Stay in B
                out = 1'b0;
            end
        2'b10: // State C
            begin
                if(!in)
                    next_state = 2'b00; // Go to A
                else
                    next_state = 2'b11; // Go to D
                out = 1'b0;
            end
        2'b11: // State D
            begin
                if(!in)
                    next_state = 2'b10; // Go to C
                else
                    next_state = 2'b01; // Go to B
                out = 1'b1;
            end
        default:
            next_state = 2'b00; // Default to state A
            out = 1'b0;
    endcase
end

endmodule