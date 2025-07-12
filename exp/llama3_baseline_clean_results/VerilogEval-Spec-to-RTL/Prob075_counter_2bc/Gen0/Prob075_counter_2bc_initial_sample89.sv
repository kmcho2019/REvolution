module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to 2'b01
        state <= 2'b01;
    end else if (train_valid) begin
        // Increment if train_taken is high, up to a maximum of 3
        if (train_taken && state < 3) begin
            state <= state + 1;
        // Decrement if train_taken is low, down to a minimum of 0
        end else if (!train_taken && state > 0) begin
            state <= state - 1;
        end
    end // train_valid
    // If not training, keep the state unchanged
end

endmodule