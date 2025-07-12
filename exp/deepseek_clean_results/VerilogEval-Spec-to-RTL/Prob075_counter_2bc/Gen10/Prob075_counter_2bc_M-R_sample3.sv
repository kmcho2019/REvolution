module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// Sequential logic with arithmetic operations
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset to weakly not-taken
    end
    else if (train_valid) begin
        // Increment if taken (saturate at 3), decrement if not taken (saturate at 0)
        state <= train_taken ? (state == 2'b11 ? 2'b11 : state + 1) :
                              (state == 2'b00 ? 2'b00 : state - 1);
    end
    // else hold current state
end

endmodule