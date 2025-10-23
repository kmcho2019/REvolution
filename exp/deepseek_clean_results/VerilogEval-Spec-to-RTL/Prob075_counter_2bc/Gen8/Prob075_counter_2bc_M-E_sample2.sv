module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// Arithmetic-based implementation
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Weakly not-taken on reset
    end
    else if (train_valid) begin
        // Update counter with saturation logic
        state <= train_taken ? 
                (state == 2'b11 ? 2'b11 : state + 1'b1) :  // Increment with saturation
                (state == 2'b00 ? 2'b00 : state - 1'b1);   // Decrement with saturation
    end
    // Else hold current state (implicit)
end

endmodule