module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = increment, 1 = decrement
wire at_max = &wave;  // AND reduction for wave==31
wire at_min = ~|wave; // NOR reduction for wave==0
wire clk_enable = ~(at_max & ~direction) & ~(at_min & direction);

// Gray code conversion
wire [4:0] gray_wave = wave ^ {1'b0, wave[4:1]};

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end else if (clk_enable) begin
        // Shared arithmetic logic
        wave <= direction ? wave - 1 : wave + 1;
        
        // State transitions at boundaries
        if (at_max) direction <= 1'b1;
        else if (at_min) direction <= 1'b0;
    end
end

// Gray code output
assign wave_out = gray_wave;

endmodule