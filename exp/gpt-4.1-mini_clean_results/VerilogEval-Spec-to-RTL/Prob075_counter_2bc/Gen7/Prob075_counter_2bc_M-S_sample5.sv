module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken reset state
        end else if (train_valid) begin
            // Compute delta: +1 if taken, -1 if not taken
            // Add delta to state, saturate between 0 and 3
            if (train_taken) begin
                state <= (state == 2'd3) ? 2'd3 : state + 1;
            end else begin
                state <= (state == 2'd0) ? 2'd0 : state - 1;
            end
        end
        // else no assignment, hold state without toggling register
    end

endmodule