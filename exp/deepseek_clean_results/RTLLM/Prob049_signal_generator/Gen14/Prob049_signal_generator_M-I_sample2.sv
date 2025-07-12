module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = increment, 1 = decrement
wire at_max = &wave;      // All bits 1 (31)
wire at_min = ~|wave;     // All bits 0 (0)
wire change_direction = (at_max & ~direction) | (at_min & direction);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end else begin
        if (change_direction) begin
            direction <= ~direction;
            // No wave update this cycle (implicit clock gating)
        end else begin
            wave <= direction ? wave - 1'b1 : wave + 1'b1;
        end
    end
end

endmodule