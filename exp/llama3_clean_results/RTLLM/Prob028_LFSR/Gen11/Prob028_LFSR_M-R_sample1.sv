// Refactored LFSR implementation
module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output reg [3:0] out // 4-bit output representing the current state of the LFSR
);

// Calculate the feedback value
wire feedback;
assign feedback = ~(out[3] ^ out[2]);

always @ (posedge clk) begin
    if (rst) begin
        // Initialize with a non-zero value for the LFSR to generate a sequence
        out <= 4'b1001; 
    end else begin
        // Shift the register and insert the new feedback value
        out <= {out[2:0], feedback};
    end
end

endmodule

// Refactored testbench to verify the LFSR module
module tb_LFSR;
reg clk_reg; // Clock signal register
reg rst_reg; // Active high reset signal register
wire [3:0] out; // 4-bit output representing the current state of the LFSR

LFSR uut (.clk(clk_reg), .rst(rst_reg), .out(out));

initial begin
    clk_reg = 0;
    rst_reg = 1;
    #10;
    rst_reg = 0;
    forever #5 clk_reg = ~clk_reg;
end

initial begin
    $monitor("out = %b", out);
    #100;
    $finish;
end

endmodule