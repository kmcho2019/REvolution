module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);

// Feedback calculation (XOR of bits 3 and 2, then inverted)
wire feedback = ~(out[3] ^ out[2]);

// Next state logic with zero protection
wire [3:0] next_state = (out == 4'b0000) ? 4'b0001 : {out[2:0], feedback};

// Sequential logic
always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000; // Initialize to zero as specified
    end else begin
        out <= next_state;
    end
end

endmodule

module LFSR_tb;

reg clk;
reg rst;
wire [3:0] out;

// Instantiate DUT with correct port mapping
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
    // Initialize
    rst = 1;
    #20;
    
    // Release reset and observe sequence
    rst = 0;
    $display("LFSR initialized to: %b", out);
    
    // Run for 32 cycles to observe full period (4-bit LFSR has max 15 states)
    #160;
    
    // Reset again to verify
    rst = 1;
    #10;
    rst = 0;
    $display("LFSR reset to: %b", out);
    
    // Run for another 16 cycles
    #80;
    $finish;
end

// Monitor state transitions
initial begin
    $monitor("Time = %0t: State = %b", $time, out);
end

endmodule