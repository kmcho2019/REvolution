module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot encoded states (count0-count6, error)
    reg [7:0] state;
    wire count_en = in && !err;  // Clock gating condition

    always @(posedge clk) begin
        if (reset) begin
            state <= 8'b00000001;  // count0 state (prev input was 0)
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Clear outputs by default
            disc <= 0;
            flag <= 0;
            err <= 0;

            // State transitions with clock gating
            if (count_en) begin
                case (1'b1)  // One-hot state transition
                    state[0]: state <= 8'b00000010;  // count0->count1
                    state[1]: state <= 8'b00000100;  // count1->count2
                    state[2]: state <= 8'b00001000;  // count2->count3
                    state[3]: state <= 8'b00010000;  // count3->count4
                    state[4]: state <= 8'b00100000;  // count4->count5
                    state[5]: state <= 8'b01000000;  // count5->count6
                    state[6]: begin                  // count6
                        state <= 8'b10000000;        // Enter error state
                        err <= 1;
                    end
                    state[7]: begin                 // error state
                        state <= 8'b10000000;        // Stay in error
                        err <= 1;                   // Keep err asserted
                    end
                    default: state <= 8'b00000001;  // Fallback to count0
                endcase
            end else if (!in) begin
                // Handle zero input cases
                case (1'b1)
                    state[5]: begin
                        state <= 8'b00000001;
                        disc <= 1;  // Discard bit after 5 ones
                    end
                    state[6]: begin
                        state <= 8'b00000001;
                        flag <= 1;  // Flag after 6 ones
                    end
                    state[7]: begin
                        state <= 8'b00000001;  // Reset from error
                    end
                    default: state <= 8'b00000001;  // Reset to count0
                endcase
            end
        end
    end

endmodule