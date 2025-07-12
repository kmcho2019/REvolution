module TopModule (
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output reg [1:0] state
);

    // Asynchronous reset and saturating counter update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken
        end else if (train_valid) begin
            if (train_taken)
                state <= (state == 2'b11) ? 2'b11 : state + 1;
            else
                state <= (state == 2'b00) ? 2'b00 : state - 1;
        end
        // else hold state unchanged
    end

endmodule