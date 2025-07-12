module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    reg state_A, state_B; // one-hot encoding: A=01, B=10

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b0;
            state_B <= 1'b1; // reset to B
        end else begin
            // Next state logic
            case ({state_B, state_A})
                2'b10: begin // currently B
                    if (in == 1'b0) begin
                        state_A <= 1'b1;
                        state_B <= 1'b0;
                    end else begin
                        state_A <= 1'b0;
                        state_B <= 1'b1;
                    end
                end
                2'b01: begin // currently A
                    if (in == 1'b0) begin
                        state_A <= 1'b0;
                        state_B <= 1'b1;
                    end else begin
                        state_A <= 1'b1;
                        state_B <= 1'b0;
                    end
                end
                default: begin
                    // Safety: if somehow in invalid state, go to reset state B
                    state_A <= 1'b0;
                    state_B <= 1'b1;
                end
            endcase
        end
    end

    // Output is 1 in B state, 0 in A state
    assign out = state_B;

endmodule