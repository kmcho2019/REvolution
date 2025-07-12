// Simplified LFSR module with integrated feedback calculation
module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output reg [3:0] out // 4-bit output representing the current state of the LFSR
);

always @ (posedge clk) begin
    if (rst) begin
        out <= 4'b0;
    end else begin
        // Feedback calculation: XOR of MSB and second MSB, then inverted
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule

// Minimal testbench to verify the LFSR module
module tb_LFSR;
reg clk; // Clock signal
reg rst; // Active high reset signal
wire [3:0] out; // 4-bit output

LFSR uut (.clk(clk), .rst(rst), .out(out));

initial begin
    clk = 1'b0; // Initialize clock to low
    rst = 1'b1; // Initialize reset to high
    #10; // Wait for 10 time units
    rst = 1'b0; // Deassert reset
end

always #5 clk = ~clk; // Toggle clock every 5 time units

initial begin
    #100; // Wait for 100 time units
    $finish; // Finish the simulation
end

endmodule