module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

// Combinational direction signal (0=inc, 1=dec)
wire direction = wave[4] && (wave != 5'b11111);

// Next wave value calculation
wire [4:0] next_wave = direction ? (wave - 1'b1) : (wave + 1'b1);

// Single always block for synchronous behavior
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
    end else begin
        wave <= next_wave;
    end
end

endmodule