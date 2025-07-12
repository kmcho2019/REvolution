module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

// Next wave value calculation using continuous assignment
wire [4:0] next_wave = (~rst_n) ? 5'b0 : 
                      (wave == 5'b11111) ? wave - 1'b1 :
                      (wave == 5'b00000) ? wave + 1'b1 :
                      (wave[4]) ? wave - 1'b1 : wave + 1'b1;

always @(posedge clk) begin
    wave <= next_wave;
end

endmodule