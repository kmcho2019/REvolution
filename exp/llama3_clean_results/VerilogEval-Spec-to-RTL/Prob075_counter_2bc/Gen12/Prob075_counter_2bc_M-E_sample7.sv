module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg; // Internal register to hold the counter value
assign state = state_reg; // Continuous assignment to output the counter value

wire incr; // Increment signal
assign incr = train_valid && train_taken && (state_reg < 2'b11);

wire decr; // Decrement signal
assign decr = train_valid && !train_taken && (state_reg > 2'b00);

// Sequential logic to update the state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01; // Asynchronous reset
    end else if (incr && !decr) begin
        state_reg <= state_reg + 2'b01; // Increment
    end else if (!incr && decr) begin
        state_reg <= state_reg - 2'b01; // Decrement
    end else begin
        state_reg <= state_reg; // No change
    end
end

endmodule