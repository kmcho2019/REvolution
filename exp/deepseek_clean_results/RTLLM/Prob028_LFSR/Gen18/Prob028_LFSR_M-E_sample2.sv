module LFSR (
    input wire clk,            // Clock input
    input wire rst,            // Active-high synchronous reset
    output reg [3:0] out,      // Current LFSR state
    output wire [3:0] next_out // Next state (combinational)
);

// Feedback polynomial rotation counter
reg [2:0] poly_counter;
wire [1:0] poly_select = poly_counter[1:0];

// Feedback calculation with rotating polynomials
wire feedback;
assign feedback = (poly_select == 2'b00) ? ~(out[3] ^ out[2]) :  // x^4 + x^3 + 1
                  (poly_select == 2'b01) ? ~(out[3] ^ out[0]) :  // x^4 + x + 1
                  (poly_select == 2'b10) ? ~(out[3] ^ out[2] ^ out[1] ^ out[0]) : // x^4 + x^3 + x^2 + x + 1
                  ~(out[3] ^ out[1]); // x^4 + x^2 + 1

// Next state calculation (combinational)
assign next_out = (out == 4'b0000) ? 4'b0001 : {out[2:0], feedback};

// Clocked behavior
always @(posedge clk) begin
    if (rst) begin
        // Self-seeding based on simulation time (lower 4 bits)
        out <= $time % 15 + 1; // Ensure non-zero
        poly_counter <= 0;
    end
    else begin
        // Normal operation with zero-state protection
        out <= next_out;
        
        // Rotate feedback polynomial every 8 cycles
        poly_counter <= poly_counter + 1;
    end
end

endmodule

module LFSR_tb;

reg clk;
reg rst;
wire [3:0] out;
wire [3:0] next_out;

// Instantiate the LFSR
LFSR dut (
    .clk(clk),
    .rst(rst),
    .out(out),
    .next_out(next_out)
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
    
    // Release reset and observe self-seeding
    rst = 0;
    $display("LFSR self-seeded to: %b", out);
    
    // Run for several cycles
    #200;
    
    // Test reset during operation
    rst = 1;
    #10;
    rst = 0;
    $display("LFSR reseeded to: %b", out);
    
    // Continue operation
    #100;
    
    $finish;
end

// Monitor the output
initial begin
    $monitor("Time = %0t: State = %b, Next = %b", $time, out, next_out);
end

endmodule