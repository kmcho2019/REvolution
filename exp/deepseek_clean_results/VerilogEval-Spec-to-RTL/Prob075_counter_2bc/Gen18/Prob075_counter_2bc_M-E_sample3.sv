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
        // Calculate next state with saturation
        state <= train_taken ? 
                 (state == 2'b11 ? 2'b11 : state + 1) :  // Increment with saturation at 3
                 (state == 2'b00 ? 2'b00 : state - 1);  // Decrement with saturation at 0
    end
    // else hold current state (implicit)
end

endmodule