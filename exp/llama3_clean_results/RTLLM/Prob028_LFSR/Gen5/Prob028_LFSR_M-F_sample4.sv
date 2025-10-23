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
reg rst; // Changed to reg to allow direct assignment
reg [3:0] out_value; // Using a reg to store the output value for display

LFSR uut (
   .clk(clk),
   .rst(rst), // Correctly connected rst signal
   .out(out_value)
);

initial begin
    clk = 0;
    rst = 1; // Initialize rst to high for reset
    #5;
    rst = 0; // Deassert rst after reset
    #10;
    $display("Initial Output: %b", out_value);
    #10;
    $display("Output after some time: %b", out_value);
    #10;
    $finish;
end

always #5 clk = ~clk;

endmodule