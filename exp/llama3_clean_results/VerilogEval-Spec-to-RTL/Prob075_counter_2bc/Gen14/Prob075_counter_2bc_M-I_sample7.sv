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
        state_reg <= 2'b01; // Asynchronous reset to the LOW state
    end else if (train_valid) begin
        if (train_taken) begin
            if (state_reg < 3) begin
                state_reg <= state_reg + 1; // Increment the counter if train_taken is high
            end
        end else begin
            if (state_reg > 0) begin
                state_reg <= state_reg - 1; // Decrement the counter if train_taken is low
            end
        end
    end
end

endmodule