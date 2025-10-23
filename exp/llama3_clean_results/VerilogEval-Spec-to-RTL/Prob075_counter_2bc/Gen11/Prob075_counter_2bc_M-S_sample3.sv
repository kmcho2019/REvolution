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
        state_reg <= 2'b01; // Asynchronous reset to the LOW state (2'b01)
    end else begin
        case (1'b1)
            1'b1: begin
                if (train_valid) begin
                    if (train_taken) begin
                        if (state_reg == 2'b11) begin // Maximum value reached
                            state_reg <= 2'b11;
                        end else begin
                            state_reg <= state_reg + 1'b1; // Increment the counter
                        end
                    end else begin
                        if (state_reg == 2'b00) begin // Minimum value reached
                            state_reg <= 2'b00;
                        end else begin
                            state_reg <= state_reg - 1'b1; // Decrement the counter
                        end
                    end
                end else begin
                    state_reg <= state_reg; // Remain unchanged if train_valid is low
                end
            end
        endcase
    end
end

endmodule