module LFSR (
    input wire clk,        // Clock input
    input wire rst,        // Active-high synchronous reset
    output wire [3:0] out  // 4-bit LFSR state output
);

reg [3:0] state;           // Internal state register

// Continuous assignment for feedback (XOR bits 3 and 2, then invert)
wire feedback = ~(state[3] ^ state[2]);

// Continuous assignment for output
assign out = state;

// Sequential state update
always @(posedge clk) begin
    if (rst) begin
        state <= 4'b0001;  // Initialize to valid starting state
    end
    else begin
        // Shift left and insert feedback at LSB
        state <= {state[2:0], feedback};
    end
end

endmodule

module LFSR_tb;

reg clk;
reg rst;
wire [3:0] out;

// Instantiate the LFSR
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
    // Initialize inputs
    rst = 1;
    
    // Release reset after 10 time units
    #10 rst = 0;
    
    // Run for enough cycles to see all states (15 states * 10ns = 150ns)
    #150;
    
    $display("Simulation complete");
    $finish;
end

// Monitor the output
initial begin
    $monitor("Time = %0t, out = %4b", $time, out);
end

endmodule