module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    wire [1:0] incremented = (state == 2'd3) ? 2'd3 : state + 2'd1;
    wire [1:0] decremented = (state == 2'd0) ? 2'd0 : state - 2'd1;
    wire [1:0] next_state = train_valid ? (train_taken ? incremented : decremented) : state;
    wire        update_en = train_valid;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;  // weakly not-taken reset state
        else if (update_en)
            state <= next_state;
        // else retain previous state without update to reduce switching
    end

endmodule