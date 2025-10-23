module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg; // Internal register to hold the counter value
assign state = state_reg; // Continuous assignment to output the counter value

reg [1:0] next_state; // Variable to track the next state

// Combinational logic to determine the next state
always @(*) begin
    case (state_reg)
        2'b00: next_state = (train_valid && train_taken) ? 2'b01 : 2'b00;
        2'b01: next_state = (train_valid && train_taken) ? 2'b10 : (train_valid && !train_taken) ? 2'b00 : 2'b01;
        2'b10: next_state = (train_valid && train_taken) ? 2'b11 : (train_valid && !train_taken) ? 2'b01 : 2'b10;
        2'b11: next_state = (train_valid && !train_taken) ? 2'b10 : 2'b11;
        default: next_state = 2'b01; // Default case for unexpected values
    endcase
end

// Sequential logic to update the state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01; // Asynchronous reset
    end else begin
        state_reg <= next_state; // Update the state register
    end
end

endmodule