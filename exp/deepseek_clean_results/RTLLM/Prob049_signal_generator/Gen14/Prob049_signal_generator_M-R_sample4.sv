module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;
wire [4:0] next_wave;

// Combinational next state logic
assign next_wave = direction ? (wave - 1'b1) : (wave + 1'b1);

// Combinational direction logic
wire next_direction = (wave == 5'b00000) ? 1'b0 : 
                     (wave == 5'b11111) ? 1'b1 : 
                     direction;

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end else begin
        wave <= next_wave;
        direction <= next_direction;
    end
end

endmodule