module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    // Sequential logic with asynchronous positive edge reset
    // and enable update only on train_valid.
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken reset state
        end else if (train_valid) begin
            // saturating increment/decrement using arithmetic and boundary checks
            if (train_taken) begin
                if (state != 2'b11)
                    state <= state + 2'd1;
                else
                    state <= state; // saturate at 3
            end else begin
                if (state != 2'b00)
                    state <= state - 2'd1;
                else
                    state <= state; // saturate at 0
            end
        end
        // else hold state unchanged
    end

endmodule