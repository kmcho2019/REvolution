module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset to weakly not-taken (2'b01)
    end else begin
        if (train_valid) begin
            if (train_taken && (state < 2'b11)) begin
                state <= state + 1;  // Increment counter if train_taken is high and counter is not at maximum
            end else if (!train_taken && (state > 2'b00)) begin
                state <= state - 1;  // Decrement counter if train_taken is low and counter is not at minimum
            end
        end
    end
end

endmodule