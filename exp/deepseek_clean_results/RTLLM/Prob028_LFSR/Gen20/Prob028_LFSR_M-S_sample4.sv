module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);

// Feedback calculation (XOR of bits 3 and 2, then inverted)
wire feedback = ~(out[3] ^ out[2]);

// Sequential logic
always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000; // Initialize to 0 as specified
    end else begin
        out <= {out[2:0], feedback}; // Shift left and insert feedback
    end
end

endmodule

module LFSR_tb;

reg clk;
reg rst;
wire [3:0] out;

// Instantiation
LFSR dut (
    .clk(clk),
    .rst(rst),
    .out(out)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test sequence
initial begin
    rst = 1;
    #20;
    
    rst = 0;
    $display("LFSR initialized to: %b", out);
    
    #200;
    
    rst = 1;
    #10;
    rst = 0;
    $display("LFSR reset to: %b", out);
    
    #100;
    $finish;
end

// Monitor
initial begin
    $monitor("Time = %0t: State = %b", $time, out);
end

endmodule