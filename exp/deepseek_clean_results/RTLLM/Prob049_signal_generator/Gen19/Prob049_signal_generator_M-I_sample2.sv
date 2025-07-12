module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = increment, 1 = decrement
reg change_direction_reg;
wire [4:0] next_wave = direction ? wave - 1'b1 : wave + 1'b1;
wire at_max = &wave;      // All bits 1 (31)
wire at_min = ~|wave;     // All bits 0 (0)

// Register direction change condition to break timing path
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        change_direction_reg <= 1'b0;
    end else begin
        change_direction_reg <= (at_max & ~direction) | (at_min & direction);
    end
end

// Explicit clock gating for power optimization
wire wave_enable = ~change_direction_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end else begin
        if (change_direction_reg) begin
            direction <= ~direction;
        end
        if (wave_enable) begin
            wave <= next_wave;
        end
    end
end

endmodule