module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

reg [1:0] state;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b01;  // Reset to weakly not-taken
    end else if(train_valid) begin
        if(train_taken) begin
            if(state < 3) begin
                state <= state + 1;  // Increment but not beyond 3
            end
        end else begin
            if(state > 0) begin
                state <= state - 1;  // Decrement but not below 0
            end
        end
    end
    // else do nothing, keep the state unchanged
end

endmodule