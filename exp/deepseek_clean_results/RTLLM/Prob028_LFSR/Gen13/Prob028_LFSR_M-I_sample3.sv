module LFSR #(
    parameter WIDTH = 4
) (
    input wire clk,            // Clock input
    input wire rst,            // Active-high synchronous reset
    input wire load,           // Load control for seed
    input wire [WIDTH-1:0] seed, // Initial seed value
    output reg [WIDTH-1:0] out // Current LFSR state
);

always @(posedge clk) begin
    if (rst) begin
        out <= {1'b1,{(WIDTH-1){1'b0}}}; // Initialize to 4'b0001 on reset
    end else if (load) begin
        out <= seed;                     // Load seed if requested
    end else begin
        // Shift left and insert XNOR feedback at LSB
        out <= {out[WIDTH-2:0], ~(out[WIDTH-1] ^ out[WIDTH-2])};
    end
end

endmodule