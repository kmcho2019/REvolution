module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = increment, 1 = decrement
reg [4:0] next_wave;
wire at_max = &wave;       // wave == 5'b11111
wire at_min = ~|wave;      // wave == 5'b00000
wire clk_en = ~(at_max & ~direction) & ~(at_min & direction);

// Convert binary to Gray code
wire [4:0] gray_wave = wave ^ {1'b0, wave[4:1]};

always @(*) begin
    if (direction) begin
        next_wave = wave - 1'b1;
    end else begin
        next_wave = wave + 1'b1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end else if (clk_en) begin
        wave <= next_wave;
        if (at_max) direction <= 1'b1;
        else if (at_min) direction <= 1'b0;
    end
end

assign wave = gray_wave;

endmodule