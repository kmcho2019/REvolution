module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

wire direction = wave[0];  // Use LSB as direction flag
wire [4:0] next_wave = wave + (direction ? -5'd1 : 5'd1);
wire at_max = &wave[4:1] & ~direction;  // wave == 31 and going up
wire at_min = ~|wave[4:1] & direction;  // wave == 0 and going down

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;  // Starts at 0, direction bit 0 means increment
    end else begin
        wave <= (at_max || at_min) ? {wave[4:1], ~wave[0]} : next_wave;
    end
end

endmodule