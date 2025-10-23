module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding
    reg state_A, state_B;

    // Combinational output logic
    assign z = (state_A & x) | (state_B & ~x);

    // State transition and reset logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end
        else begin
            case ({state_A, state_B})
                2'b10: begin // State A
                    state_A <= ~x;
                    state_B <= x;
                end
                2'b01: begin // State B
                    state_A <= 1'b0;
                    state_B <= 1'b1;
                end
                default: begin // Shouldn't happen with proper one-hot
                    state_A <= 1'b1;
                    state_B <= 1'b0;
                end
            endcase
        end
    end

endmodule