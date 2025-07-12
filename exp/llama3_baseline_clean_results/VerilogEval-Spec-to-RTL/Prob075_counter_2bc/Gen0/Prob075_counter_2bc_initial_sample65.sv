module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset
        state <= 2'b01;
    end else begin
        // Default: do not change state
        state <= state;
        
        if (train_valid) begin
            // If training, update state based on train_taken
            if (train_taken) begin
                // Increment, but saturate at 3
                if (state < 2'd3) begin
                    state <= state + 1'b1;
                end
            end else begin
                // Decrement, but saturate at 0
                if (state > 2'd0) begin
                    state <= state - 1'b1;
                end
            end
        end
    end
end

endmodule