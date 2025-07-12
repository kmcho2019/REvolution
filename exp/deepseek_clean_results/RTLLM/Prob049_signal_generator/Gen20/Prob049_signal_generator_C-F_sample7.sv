module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = increment, 1 = decrement
wire [4:0] next_wave = direction ? wave - 1'b1 : wave + 1'b1;
wire at_max = &wave;      // All bits 1 (31)
wire at_min = ~|wave;     // All bits 0 (0)

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end else begin
        if ((direction && ~at_min) || (~direction && ~at_max)) begin
            wave <= next_wave;
        end
        if (at_max) direction <= 1'b1;
        if (at_min) direction <= 1'b0;
    end
end

endmodule