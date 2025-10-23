module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset to weakly not-taken
    end
    else if (train_valid) begin
        state <= train_taken ? 
                (state == 2'b11 ? 2'b11 : state + 1'b1) :  // Increment with saturation
                (state == 2'b00 ? 2'b00 : state - 1'b1);  // Decrement with saturation
    end
    // else state remains unchanged (implicit)
end

endmodule