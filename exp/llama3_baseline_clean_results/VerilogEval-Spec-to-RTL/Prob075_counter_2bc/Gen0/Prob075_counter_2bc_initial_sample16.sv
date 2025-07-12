module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b01; // Reset to weakly not-taken (2'b01) on asynchronous reset
    end else if(train_valid) begin
        if(train_taken && state < 3) begin
            state <= state + 1; // Increment if train_valid and train_taken are high, and state is not at max
        end else if(!train_taken && state > 0) begin
            state <= state - 1; // Decrement if train_valid is high and train_taken is low, and state is not at min
        end
    end
end

endmodule