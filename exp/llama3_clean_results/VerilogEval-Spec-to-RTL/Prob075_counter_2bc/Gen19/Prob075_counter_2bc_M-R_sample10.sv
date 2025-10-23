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
        state_reg <= 2'b01; // Asynchronous reset to the value 1
    end else begin
        if (train_valid) begin
            if (train_taken) begin
                state_reg <= (state_reg == 3)? 3 : state_reg + 1; // Increment with saturation
            end else begin
                state_reg <= (state_reg == 0)? 0 : state_reg - 1; // Decrement with saturation
            end
        end else begin
            state_reg <= state_reg; // Keep the value unchanged if train_valid is low
        end
    end
end

endmodule