module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

wire at_max = &wave;       // All bits 1 (31)
wire at_min = ~|wave;      // All bits 0 (0)
wire [5:0] next_wave = {1'b0, wave} + (at_max ? 6'h3F : 6'h01); // +1 or -1 (via overflow)

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
    end else begin
        wave <= next_wave[4:0];
    end
end

endmodule