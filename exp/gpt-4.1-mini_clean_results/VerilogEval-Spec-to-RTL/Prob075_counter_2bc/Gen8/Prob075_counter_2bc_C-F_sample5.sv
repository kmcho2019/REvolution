module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

    wire [1:0] incremented = (state == 2'd3) ? 2'd3 : (state + 2'd1);
    wire [1:0] decremented = (state == 2'd0) ? 2'd0 : (state - 2'd1);
    wire [1:0] next_state = train_taken ? incremented : decremented;
    wire        update_enable = train_valid;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken reset state
        end else if (update_enable) begin
            state <= next_state;
        end
        // else keep state unchanged implicitly by not updating state
    end

endmodule