module LFSR (
    input wire clk,        // Clock input
    input wire rst,        // Active-high synchronous reset
    output reg [3:0] out   // Current LFSR state
);

// Feedback polynomial selection (toggle every 16 cycles)
reg fb_poly_select;
wire feedback = fb_poly_select ? ~(out[3] ^ out[0]) :  // x^4 + x + 1
                                ~(out[3] ^ out[2]);    // x^4 + x^3 + 1

// Clocked behavior
always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001;  // Fixed non-zero seed
        fb_poly_select <= 0;
    end
    else begin
        // Normal operation with zero-state protection
        out <= (out == 4'b0000) ? 4'b0001 : {out[2:0], feedback};
        
        // Toggle feedback polynomial every 16 cycles
        if (&out) fb_poly_select <= ~fb_poly_select;
    end
end

endmodule

module LFSR_tb;

reg clk;
reg rst;
wire [3:0] out;

// Instantiate the LFSR with all ports
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
    // Initialize and reset
    rst = 1;
    #20;
    
    // Release reset
    rst = 0;
    $display("LFSR initialized to: %b", out);
    
    // Run for several cycles
    #200;
    
    // Test reset during operation
    rst = 1;
    #10;
    rst = 0;
    $display("LFSR re-initialized to: %b", out);
    
    // Continue operation
    #100;
    
    $finish;
end

// Monitor the output
initial begin
    $monitor("Time = %0t: State = %b", $time, out);
end

endmodule