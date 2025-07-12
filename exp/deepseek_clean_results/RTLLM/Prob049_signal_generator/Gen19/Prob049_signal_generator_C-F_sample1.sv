module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0=increment, 1=decrement

// Efficient boundary detection
wire at_max = &wave;      // All bits 1 (31)
wire at_min = ~|wave;     // No bits 1 (0)
wire change_dir = (direction ? at_min : at_max);

// Pre-calculated next wave value
wire [4:0] next_wave = direction ? (wave - 1'b1) : (wave + 1'b1);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end else if (change_dir) begin
        direction <= ~direction;
        // Wave holds value during direction change
    end else begin
        wave <= next_wave;
    end
end

endmodule