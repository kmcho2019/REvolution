module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

    always @(state or in) begin
        case (state)
            2'b00: // State A
                begin
                    if (!in) begin
                        next_state = 2'b00; // Next state is A
                    end else begin
                        next_state = 2'b01; // Next state is B
                    end
                    out = 1'b0; // Output is 0
                end

            2'b01: // State B
                begin
                    if (!in) begin
                        next_state = 2'b10; // Next state is C
                    end else begin
                        next_state = 2'b01; // Next state is B
                    end
                    out = 1'b0; // Output is 0
                end

            2'b10: // State C
                begin
                    if (!in) begin
                        next_state = 2'b00; // Next state is A
                    end else begin
                        next_state = 2'b11; // Next state is D
                    end
                    out = 1'b0; // Output is 0
                end

            2'b11: // State D
                begin
                    if (!in) begin
                        next_state = 2'b10; // Next state is C
                    end else begin
                        next_state = 2'b01; // Next state is B
                    end
                    out = 1'b1; // Output is 1
                end

            default:
                next_state = 2'b00; // Default next state is A
                out = 1'b0; // Default output is 0
        endcase
    end

endmodule