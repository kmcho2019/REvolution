module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

    // Next state logic and register combined
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // Reset to weakly not-taken
        end else if (train_valid) begin
            // Single arithmetic expression with saturation
            state <= train_taken ? 
                   (state == 2'b11 ? 2'b11 : state + 1) :  // Increment with saturation
                   (state == 2'b00 ? 2'b00 : state - 1);   // Decrement with saturation
        end
        // Implicit else: state remains unchanged
    end

endmodule