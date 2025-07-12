module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding
    reg state_A, state_B;

    // Next state and output logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end
        else begin
            case ({state_A, state_B})
                2'b10: begin // State B
                    state_A <= 1'b0;
                    state_B <= 1'b1; // Stay in B regardless of x
                end
                default: begin // State A (or invalid state)
                    state_A <= ~x;
                    state_B <= x;
                end
            endcase
        end
    end

    // Mealy output depends on current state and input
    assign z = (state_A & x) | (state_B & ~x);

endmodule