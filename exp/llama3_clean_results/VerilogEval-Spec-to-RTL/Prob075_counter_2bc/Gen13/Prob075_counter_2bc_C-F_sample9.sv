module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg; // Internal register to hold the counter value
assign state = state_reg; // Continuous assignment to output the counter value

// Sequential logic to update the state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01; // Asynchronous reset
    end else begin
        case (state_reg)
            2'b00: begin
                if (train_valid && train_taken) state_reg <= 2'b01; // Increment from minimum value
                else state_reg <= 2'b00; // Maintain current value when not training or decrementing from minimum
            end
            2'b01: begin
                if (train_valid && train_taken) state_reg <= 2'b10; // Increment
                else if (train_valid && !train_taken) state_reg <= 2'b00; // Decrement
                else state_reg <= 2'b01; // Maintain current value when not training
            end
            2'b10: begin
                if (train_valid && train_taken) state_reg <= 2'b11; // Increment
                else if (train_valid && !train_taken) state_reg <= 2'b01; // Decrement
                else state_reg <= 2'b10; // Maintain current value when not training
            end
            2'b11: begin
                if (train_valid && !train_taken) state_reg <= 2'b10; // Decrement
                else state_reg <= 2'b11; // Maintain current value when not training or at maximum
            end
            default: state_reg <= 2'b01; // Default case for unexpected values
        endcase
    end
end

endmodule