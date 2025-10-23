module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = increment, 1 = decrement

// Efficient boundary detection
wire at_max = &wave;          // All bits high (31)
wire at_min = ~|wave;         // All bits low (0)

// Next state and wave calculation
wire toggle_direction = (at_max && !direction) || (at_min && direction);
wire [4:0] next_wave = direction ? wave - 1'b1 : wave + 1'b1;

// State control (direction) update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        direction <= 1'b0;
    end else if (toggle_direction) begin
        direction <= ~direction;
    end
end

// Wave generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
    end else begin
        wave <= next_wave;
    end
end

endmodule