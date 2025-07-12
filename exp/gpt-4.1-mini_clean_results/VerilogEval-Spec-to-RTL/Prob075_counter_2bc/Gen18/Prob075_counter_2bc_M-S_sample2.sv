module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire        train_valid,
    input  wire        train_taken,
    output reg  [1:0]  state
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // reset to weakly not-taken
        end else if (train_valid) begin
            if (train_taken) begin
                // increment saturating at 3
                state <= (state == 2'd3) ? 2'd3 : state + 1;
            end else begin
                // decrement saturating at 0
                state <= (state == 2'd0) ? 2'd0 : state - 1;
            end
        end
        // hold state if train_valid == 0
    end

endmodule