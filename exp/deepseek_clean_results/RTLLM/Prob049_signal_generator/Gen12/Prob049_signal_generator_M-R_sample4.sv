module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state;  // 0 = incrementing, 1 = decrementing
wire next_state;
wire [4:0] next_wave;

// Combinational logic for next state and wave value
assign next_state = (~rst_n) ? 1'b0 : 
                   (state == 0) ? (&wave ? 1'b1 : state) :
                   (|wave == 0 ? 1'b0 : state);

assign next_wave = (~rst_n) ? 5'b0 :
                  (state == 0) ? ((&wave) ? wave : wave + 1) :
                  ((|wave == 0) ? wave : wave - 1);

// Sequential logic for state and wave registers
always @(posedge clk) begin
    state <= next_state;
    wave <= next_wave;
end

endmodule