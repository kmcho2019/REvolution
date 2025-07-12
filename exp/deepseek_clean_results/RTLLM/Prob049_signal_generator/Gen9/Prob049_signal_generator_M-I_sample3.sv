module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

wire [5:0] next_wave = {1'b0, wave} + (wave[4] ? -6'd1 : 6'd1);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
    end else begin
        wave <= next_wave[4:0];
    end
end

endmodule