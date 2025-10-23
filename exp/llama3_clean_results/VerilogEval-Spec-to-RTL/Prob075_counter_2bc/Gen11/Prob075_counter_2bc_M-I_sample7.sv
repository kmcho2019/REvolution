module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg; // Internal register to hold the counter value
assign state = state_reg; // Continuous assignment to output the counter value

// Next state logic
reg [1:0] next_state;
always @(*) begin
    if (areset) begin
        next_state = 2'b01; // Asynchronous reset
    end else if (train_valid) begin
        case ({train_taken, state_reg})
            {1'b1, 2'b11}: next_state = 2'b11; // Saturate at max
            {1'b1, 2'b00}: next_state = 2'b01; // Increment from 0
            {1'b1, 2'b01}: next_state = 2'b11; // Increment from 1
            {1'b0, 2'b00}: next_state = 2'b00; // Saturate at min
            {1'b0, 2'b01}: next_state = 2'b00; // Decrement to 0
            {1'b0, 2'b11}: next_state = 2'b01; // Decrement from 3
            default: next_state = state_reg; // Maintain current value
        endcase
    end else begin
        next_state = state_reg; // Maintain current value when not training
    end
end

// Register update logic
always @(posedge clk) begin
    state_reg <= next_state; // Update state register on clock edge
end

// Asynchronous reset
always @(posedge areset) begin
    state_reg <= 2'b01; // Asynchronous reset
end

endmodule