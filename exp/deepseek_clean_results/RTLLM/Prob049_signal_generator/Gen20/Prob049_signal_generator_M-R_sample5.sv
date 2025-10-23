module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = increment, 1 = decrement

// Combinational boundary detection
wire at_max = (wave == 5'b11111);
wire at_min = (wave == 5'b00000);

// Next state and data calculation
wire change_direction = (at_max & ~direction) | (at_min & direction);
wire [4:0] next_wave = direction ? wave - 1'b1 : wave + 1'b1;

// State control (direction)
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        direction <= 1'b0;
    end else if (change_direction) begin
        direction <= ~direction;
    end
end

// Data path (wave generation)
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
    end else if (!change_direction) begin
        wave <= next_wave;
    end
    // implicit hold when changing direction
end

endmodule