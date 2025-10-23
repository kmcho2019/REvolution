module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

    always_comb begin
        case(state)
            2'b00: // State A
                begin
                    if (!in)
                        next_state = 2'b00; // Stay in A
                    else
                        next_state = 2'b01; // Move to B
                    out = 1'b0; // Output is 0
                end
            2'b01: // State B
                begin
                    if (!in)
                        next_state = 2'b10; // Move to C
                    else
                        next_state = 2'b01; // Stay in B
                    out = 1'b0; // Output is 0
                end
            2'b10: // State C
                begin
                    if (!in)
                        next_state = 2'b00; // Move to A
                    else
                        next_state = 2'b11; // Move to D
                    out = 1'b0; // Output is 0
                end
            2'b11: // State D
                begin
                    if (!in)
                        next_state = 2'b10; // Move to C
                    else
                        next_state = 2'b01; // Move to B
                    out = 1'b1; // Output is 1
                end
            default:
                next_state = 2'b00; // Default state
                out = 1'b0;
        endcase
    end

endmodule