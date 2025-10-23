module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave_gray  // Gray code output
);

reg direction;  // 0 = increment, 1 = decrement
wire [4:0] wave_binary;
wire [4:0] next_wave = wave_binary + {4'b0,~direction};  // Unified adder
wire at_max = &wave_binary;
wire at_min = ~|wave_binary;

// Binary to Gray conversion
assign wave_binary = {1'b0, wave_gray[4:1]} ^ wave_gray;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave_gray <= 5'b0;
        direction <= 1'b0;
    end else begin
        // Update direction immediately at boundaries
        if (at_max) direction <= 1'b1;
        else if (at_min) direction <= 1'b0;
        
        // Update wave value (binary)
        wave_gray <= (next_wave[4:1] ^ next_wave[3:0]);  // Binary to Gray
    end
end

endmodule