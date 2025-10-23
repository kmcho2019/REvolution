module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;          // Current direction (0=inc, 1=dec)
reg next_direction;     // Pre-computed next direction
wire update_wave;       // Clock gating control

// Simplified boundary detection
wire at_max = (wave == 5'd31);
wire at_min = (wave == 5'd0);

// Pre-compute next direction one cycle early
always @(*) begin
    if (at_max) next_direction = 1'b1;
    else if (at_min) next_direction = 1'b0;
    else next_direction = direction;
end

// Clock gating control - only update wave when not changing direction
assign update_wave = ~((at_max & ~direction) | (at_min & direction));

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end else begin
        direction <= next_direction;
        
        if (update_wave) begin
            wave <= direction ? wave - 1'b1 : wave + 1'b1;
        end
    end
end

endmodule