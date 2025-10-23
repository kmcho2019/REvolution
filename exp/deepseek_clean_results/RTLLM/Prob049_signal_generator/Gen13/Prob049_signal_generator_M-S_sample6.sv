module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
    end else begin
        wave <= (wave == 5'b11111) ? (wave - 1'b1) :  // at max, start decrementing
                (wave == 5'b00000) ? (wave + 1'b1) :  // at min, start incrementing
                (wave[4]) ? (wave - 1'b1) : (wave + 1'b1); // MSB indicates direction
    end
end

endmodule