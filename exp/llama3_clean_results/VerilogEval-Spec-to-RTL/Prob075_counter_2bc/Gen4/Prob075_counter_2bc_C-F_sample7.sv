module TopModule(
    input           clk,
    input           areset,
    input           train_valid,
    input           train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to state 1 (weakly not-taken)
    end else begin
        case (1'b1)
            1'b1: begin
                if (train_valid) begin
                    if (train_taken) begin
                        if (state == 2'b11) begin
                            state <= 2'b11; // Saturate at state 3
                        end else begin
                            state <= state + 1'b1; // Increment
                        end
                    end else begin
                        if (state == 2'b00) begin
                            state <= 2'b00; // Saturate at state 0
                        end else begin
                            state <= state - 1'b1; // Decrement
                        end
                    end
                end else begin
                    state <= state; // Stay in the same state if not training
                end
            end
        endcase
    end
end

endmodule