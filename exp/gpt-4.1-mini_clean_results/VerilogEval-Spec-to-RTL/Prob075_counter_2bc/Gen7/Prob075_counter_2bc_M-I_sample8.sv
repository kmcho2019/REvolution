module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    wire signed [2:0] diff = train_taken ? 3'sd1 : -3'sd1;
    wire [2:0] next_val = $signed({1'b0, state}) + diff;
    wire [1:0] saturated_val = (next_val < 0) ? 2'd0 :
                               (next_val > 3) ? 2'd3 :
                               next_val[1:0];

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // weakly not-taken reset state
        end else if (train_valid) begin
            state <= saturated_val;
        end
        // else hold state unchanged
    end

endmodule