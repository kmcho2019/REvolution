module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    // Asynchronous positive edge reset to weakly not-taken state (2'b01)
    // State updates only on train_valid assertion
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;
        end else if (train_valid) begin
            // Saturating increment/decrement using arithmetic and min/max limits
            if (train_taken) begin
                // Increment saturating at 3 (2'b11)
                state <= (state == 2'b11) ? 2'b11 : state + 1'b1;
            end else begin
                // Decrement saturating at 0 (2'b00)
                state <= (state == 2'b00) ? 2'b00 : state - 1'b1;
            end
        end
        // else hold state
    end

endmodule