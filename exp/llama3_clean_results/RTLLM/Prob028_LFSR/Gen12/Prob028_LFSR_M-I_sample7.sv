// Improved LFSR implementation
module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output reg [3:0] out // 4-bit output representing the current state of the LFSR
);

// Calculate the feedback signal according to the problem description
wire feedback = ~(out[3] ^ out[2]);

always @ (posedge clk) begin
    if (rst) begin
        // Initialize the register to a non-zero value for the LFSR to generate a sequence
        out <= 4'b1001;
    end else begin
        // Shift the register and insert the new feedback value
        out <= {out[2:0], feedback};
    end
end

endmodule

// Improved testbench to verify the LFSR module
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