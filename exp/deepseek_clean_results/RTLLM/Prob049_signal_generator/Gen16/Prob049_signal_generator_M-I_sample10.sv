module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = increment, 1 = decrement
reg change_direction_d;  // Registered direction change signal

// Combinational next state logic
wire [4:0] next_wave = direction ? wave - 1'b1 : wave + 1'b1;
wire at_max = (wave == 5'd31);
wire at_min = (wave == 5'd0);
wire change_direction = (at_max & ~direction) | (at_min & direction);

// Clock gating control
wire wave_enable = ~change_direction_d;

always @(posedge clk) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
        change_direction_d <= 1'b0;
    end else begin
        change_direction_d <= change_direction;
        
        if (change_direction_d) begin
            direction <= ~direction;
        end
        
        if (wave_enable) begin
            wave <= next_wave;
        end
    end
end

endmodule