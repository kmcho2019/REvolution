module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

wire at_max = &wave;       // wave == 5'b11111
wire at_min = ~|wave;      // wave == 5'b00000
wire direction = at_max ? 1'b1 : (at_min ? 1'b0 : direction);
wire [4:0] next_wave = direction ? (wave - 1'b1) : (wave + 1'b1);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
    end else begin
        wave <= next_wave;
    end
end

endmodule