module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state;  // 0 = incrementing, 1 = decrementing
wire next_state;
wire [4:0] next_wave;

// Combinational logic for next state and wave value
assign next_state = (state == 0) ? (wave == 31) : (wave == 0);
assign next_wave = (state == 0) ? ((wave == 31) ? wave : wave + 1) 
                                : ((wave == 0) ? wave : wave - 1);

// Sequential logic for state and wave updates
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