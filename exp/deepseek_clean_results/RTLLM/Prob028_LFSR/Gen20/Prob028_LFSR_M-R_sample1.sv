module LFSR (
    input wire clk,        // Clock input
    input wire rst,        // Active-high synchronous reset
    output reg [3:0] out  // Current LFSR state
);

// Continuous assignments for feedback signals
wire feedback_poly1 = ~(out[3] ^ out[2]);  // x^4 + x^3 + 1
wire feedback_poly2 = ~(out[3] ^ out[0]);  // x^4 + x + 1

// Polynomial selection counter
reg [3:0] poly_counter;
wire feedback = (poly_counter[3]) ? feedback_poly2 : feedback_poly1;

// Clocked behavior
always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001;       // Fixed non-zero seed
        poly_counter <= 4'b0; // Reset counter
    end
    else begin
        // Update LFSR state with zero protection
        out <= (out == 4'b0000) ? 4'b0001 : {out[2:0], feedback};
        
        // Increment polynomial counter
        poly_counter <= poly_counter + 1;
    end
end

endmodule

module LFSR_tb;

// Testbench signals
reg clk = 0;
reg rst = 1;
wire [3:0] out;

// Instantiate the LFSR
LFSR dut (
    .clk(clk),
    .rst(rst),
    .out(out)
);

// Clock generation
always #5 clk = ~clk;

// Test sequence
initial begin
    // Initialize and reset
    #20 rst = 0;
    
    // Run for several cycles
    #200;
    
    // Test reset during operation
    rst = 1;
    #10 rst = 0;
    
    // Continue operation
    #100;
    
    $finish;
end

// Monitor the output
initial begin
    $monitor("Time = %0t: State = %b", $time, out);
end

endmodule