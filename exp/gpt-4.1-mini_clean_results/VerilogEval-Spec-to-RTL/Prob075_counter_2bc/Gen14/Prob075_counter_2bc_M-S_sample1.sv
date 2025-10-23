module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken reset state
        end else if (train_valid) begin
            if (train_taken) begin
                // saturate at 3
                if (state != 2'd3)
                    state <= state + 1'b1;
            end else begin
                // saturate at 0
                if (state != 2'd0)
                    state <= state - 1'b1;
            end
        end
        // else keep state unchanged
    end

endmodule