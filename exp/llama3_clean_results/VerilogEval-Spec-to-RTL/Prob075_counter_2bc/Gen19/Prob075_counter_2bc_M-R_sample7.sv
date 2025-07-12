module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg; // Internal register to hold the counter value
assign state = state_reg; // Continuous assignment to output the state

// Sequential logic to update the state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01; // Asynchronous reset to the "weakly not-taken" state
    end else begin
        case (1'b1)
            1'b1: begin
                if (train_valid) begin
                    if (train_taken) begin
                        state_reg <= (state_reg == 2'b11) ? 2'b11 : state_reg + 1'b1; // Increment, saturating at 3
                    end else begin
                        state_reg <= (state_reg == 2'b00) ? 2'b00 : state_reg - 1'b1; // Decrement, saturating at 0
                    end
                end else begin
                    // No change when train_valid is low
                end
            end
        endcase
    end
end

endmodule