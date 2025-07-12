module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken on reset
        end else if (train_valid) begin
            if (train_taken) begin
                // Saturating increment (max 3)
                state <= (state == 2'b11) ? 2'b11 : state + 1'b1;
            end else begin
                // Saturating decrement (min 0)
                state <= (state == 2'b00) ? 2'b00 : state - 1'b1;
            end
        end
        // else hold state
    end

endmodule