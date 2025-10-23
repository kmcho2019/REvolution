module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

// Improved feedback calculation and initialization logic
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the LFSR to a non-zero initial state for better randomness
        out <= 4'b1001; // Changed to ensure a non-zero initial state with better distribution
    end else begin
        // Simplify the feedback calculation for better area efficiency
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule

module testbench;
reg clk;
reg rst;
wire [3:0] out;

LFSR uut (
    .clk(clk),
    .rst(rst),
    .out(out)
);

initial begin
    clk = 0;
    rst = 1;
    #10;
    rst = 0;
    #10;
    $display("Output: %b", out);
end

always #5 clk = ~clk;

endmodule