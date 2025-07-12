module TopModule (
    input        clk,
    input        areset,
    input        train_valid,
    input        train_taken,
    output reg [1:0] state
);

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // weakly not-taken
        else if (train_valid) begin
            // Calculate next state with saturation
            // Increment if taken, else decrement
            // Saturate between 0 and 3
            state <= (train_taken)
                        ? (state == 2'b11 ? 2'b11 : state + 1)
                        : (state == 2'b00 ? 2'b00 : state - 1);
        end
    end

endmodule