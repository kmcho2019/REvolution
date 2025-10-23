module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

    // Saturating 2-bit counter with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken reset state
        end else if (train_valid) begin
            // Update state only when training is valid
            // Saturate increment at 3 and decrement at 0
            if (train_taken) begin
                state <= (state == 2'd3) ? 2'd3 : state + 1;
            end else begin
                state <= (state == 2'd0) ? 2'd0 : state - 1;
            end
        end
        // else hold state without assignment to reduce toggling
    end

endmodule