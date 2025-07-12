module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = increment, 1 = decrement
wire [4:0] next_wave = direction ? wave - 1'b1 : wave + 1'b1;
wire at_max = &wave;      // All bits 1 (31)
wire at_min = ~|wave;     // All bits 0 (0)
wire change_direction = (at_max & ~direction) | (at_min & direction);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end else if (change_direction) begin
        direction <= ~direction;
        // Implicit clock gating - wave holds value during direction change
    end else begin
        wave <= next_wave;
    end
end

endmodule