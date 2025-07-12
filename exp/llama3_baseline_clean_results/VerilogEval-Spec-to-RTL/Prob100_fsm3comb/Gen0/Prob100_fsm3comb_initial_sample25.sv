module TopModule(
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

    always @(*) begin
        case(state)
            2'b00: // State A
                if (!in) begin
                    next_state = 2'b00; // Stay in A
                end else begin
                    next_state = 2'b01; // Move to B
                end
                out = 1'b0; // Output is 0 in state A

            2'b01: // State B
                if (!in) begin
                    next_state = 2'b10; // Move to C
                end else begin
                    next_state = 2'b01; // Stay in B
                end
                out = 1'b0; // Output is 0 in state B

            2'b10: // State C
                if (!in) begin
                    next_state = 2'b00; // Move to A
                end else begin
                    next_state = 2'b11; // Move to D
                end
                out = 1'b0; // Output is 0 in state C

            2'b11: // State D
                if (!in) begin
                    next_state = 2'b10; // Move to C
                end else begin
                    next_state = 2'b01; // Move to B
                end
                out = 1'b1; // Output is 1 in state D

            default: begin
                next_state = 2'b00; // Default next state
                out = 1'b0; // Default output
            end
        endcase
    end

endmodule