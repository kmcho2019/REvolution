module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Weakly not-taken state on reset
    end
    else if (train_valid) begin
        // Combined increment/decrement with saturation
        state <= train_taken ? (state + (state != 2'b11)) 
                            : (state - (state != 2'b00));
    end
    // else keep state unchanged (implicit)
end

endmodule