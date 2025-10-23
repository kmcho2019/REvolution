module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state;  // 0 = incrementing, 1 = decrementing

// Combinational next state and wave value logic
wire next_state;
wire [4:0] next_wave;

assign next_state = (state == 0) ? (&wave) : (~|wave);
assign next_wave = (state == 0) ? 
                   ((&wave) ? wave : wave + 1) : 
                   ((~|wave) ? wave : wave - 1);

// Sequential element updates
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        state <= 1'b0;
    end else begin
        state <= next_state;
        wave <= next_wave;
    end
end

endmodule