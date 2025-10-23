// Novel LFSR implementation using the Galois architecture
module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output reg [3:0] out // 4-bit output representing the current state of the LFSR
);

// Define the tap positions for the Galois LFSR
reg [3:0] taps;
always @ (*) begin
    taps = (out[3] ^ out[2] ^ out[1]);
end

always @ (posedge clk) begin
    if (rst) begin
        out <= 4'b1; // Initialize with a non-zero value for the LFSR to generate a sequence
    end else begin
        out <= {taps, out[3:1]}; // Shift the register and insert the new feedback value
    end
end

endmodule

// Testbench to verify the novel LFSR module
module tb_LFSR;
reg clk; // Clock signal
reg rst; // Active high reset signal
wire [3:0] out; // 4-bit output representing the current state of the LFSR

LFSR uut (.clk(clk), .rst(rst), .out(out));

initial begin
    clk = 0;
    rst = 1;
    #10;
    rst = 0;
    forever #5 clk = ~clk;
end

initial begin
    $monitor("out = %b", out);
    #100;
    $finish;
end

endmodule