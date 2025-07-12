// Corrected LFSR module
module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output reg [3:0] out // 4-bit output representing the current state of the LFSR
);

// Combinational logic block to calculate the feedback value
reg feedback;
always @(*) begin
    feedback = ~(out[3] ^ out[2]);
end

// Sequential logic block to update the LFSR state
always @ (posedge clk or posedge rst) begin
    if (rst) begin // If reset is high, initialize the register to zero
        out <= 4'b0;
    end else begin // Otherwise, shift the bits left and insert the new feedback value at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule

// Corrected testbench to verify the LFSR module
module tb_LFSR;
reg clk;
reg rst;
wire [3:0] out;

LFSR uut (.clk(clk),.rst(rst),.out(out));

initial begin
    clk = 0;
    rst = 1;
    #5;
    rst = 0;
    forever #5 clk = ~clk;
end

initial begin
    #100;
    $finish;
end

initial begin
    $monitor("out = %b", out);
end

endmodule