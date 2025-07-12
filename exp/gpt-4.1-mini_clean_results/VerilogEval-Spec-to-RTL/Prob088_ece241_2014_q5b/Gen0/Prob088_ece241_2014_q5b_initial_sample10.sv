module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);
    // One-hot state encoding
    reg state_A, state_B;

    // State update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end else begin
            // State transitions
            case (1'b1)
                state_A: begin
                    if (x)
                    begin
                        state_A <= 1'b0;
                        state_B <= 1'b1;
                    end else begin
                        state_A <= 1'b1;
                        state_B <= 1'b0;
                    end
                end
                state_B: begin
                    // In state B, stay in B always
                    state_A <= 1'b0;
                    state_B <= 1'b1;
                end
                default: begin
                    // Should never happen, reset to A
                    state_A <= 1'b1;
                    state_B <= 1'b0;
                end
            endcase
        end
    end

    // Mealy output logic combinational
    always @(*) begin
        if (state_A)
            z = x ? 1'b1 : 1'b0;
        else if (state_B)
            z = x ? 1'b0 : 1'b1;
        else
            z = 1'b0; // default safe output
    end
endmodule