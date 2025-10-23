module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg; // Internal register to hold the counter value
reg [1:0] next_state; // Intermediate signal for next state logic

// Combinational logic to determine the next state
always @(*) begin
    case (state_reg)
        2'b00: begin
            if (train_valid && train_taken) next_state = 2'b01; // Increment from minimum value
            else next_state = 2'b00; // Maintain current value when not training or decrementing from minimum
        end
'b01: begin
            if (train_valid && train_taken) next_state = 2'b10; // Increment
            else if (train_valid && !train_taken) next_state = 2'b00; // Decrement
            else next_state = 2'b01; // Maintain current value when not training
        end
'b10: begin
            if (train_valid && train_taken) next_state = 2'b11; // Increment
            else if (train_valid && !train_taken) next_state = 2'b01; // Decrement
            else next_state = 2'b10; // Maintain current value when not training
        end
'b11: begin
            if (train_valid && !train_taken) next_state = 2'b10; // Decrement
            else next_state = 2'b11; // Maintain current value when not training or at maximum
        end
        default: next_state = 2'b01; // Default case for unexpected values
    endcase
end

// Sequential logic to update the state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01; // Asynchronous reset
    end else begin
        state_reg <= next_state;
    end
end

assign state = state_reg; // Continuous assignment to output the counter value

endmodule