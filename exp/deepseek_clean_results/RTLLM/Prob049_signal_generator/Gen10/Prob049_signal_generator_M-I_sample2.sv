module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = increment, 1 = decrement
reg hold;       // Hold signal for clock gating

// Simplified boundary detection
wire at_max = &wave;       // All bits 1 (31)
wire at_min = ~|wave;      // All bits 0 (0)
wire boundary = (at_max & ~direction) | (at_min & direction);

// Separate increment/decrement paths
wire [4:0] next_inc = wave + 1'b1;
wire [4:0] next_dec = wave - 1'b1;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
        hold <= 1'b0;
    end else begin
        // Pipeline direction change to break critical path
        if (boundary) begin
            direction <= ~direction;
            hold <= 1'b1;  // Hold value for one cycle
        end else begin
            hold <= 1'b0;
        end

        // Clock gating implementation
        if (~hold) begin
            wave <= direction ? next_dec : next_inc;
        end
    end
end

endmodule