module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset state to weakly not-taken (2'b01)
    end else begin
        if (train_valid) begin
            if (train_taken) begin
                state <= (state == 2'b11)? 2'b11 : state + 1; // Saturating increment
            end else begin
                state <= (state == 2'b00)? 2'b00 : state - 1; // Saturating decrement
            end
        end else begin
            // No change when not training
        end
    end
end

endmodule