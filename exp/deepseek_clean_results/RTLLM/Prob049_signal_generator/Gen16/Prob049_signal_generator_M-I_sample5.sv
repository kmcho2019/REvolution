module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

// State encoding: MSB of wave (bit 4) indicates direction
// 0 = increment (0-30), 1 = decrement (31-1)
wire direction = wave[4];
wire at_max = (wave == 5'd30);  // Detect before actual max to allow 1-cycle update
wire at_min = (wave == 5'd1);   // Detect before actual min to allow 1-cycle update

// Pre-compute next wave value
wire [4:0] next_wave_inc = wave + 1'b1;
wire [4:0] next_wave_dec = wave - 1'b1;
wire [4:0] next_wave = direction ? next_wave_dec : next_wave_inc;

// Clock gating control
wire update_wave = ~((at_max & ~direction) | (at_min & direction));

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;  // Starts at 0 (increment mode)
    end else if (update_wave) begin
        wave <= next_wave;
    end else begin
        // Toggle direction by forcing to boundary
        wave <= direction ? 5'd0 : 5'd31;
    end
end

endmodule