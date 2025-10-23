module LFSR (
    input wire clk,        // Clock input
    input wire rst,        // Active-high synchronous reset
    output reg [3:0] out  // Current LFSR state
);

// Feedback is XOR of bits 3 and 2, then inverted
wire feedback = ~(out[3] ^ out[2]);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001;    // Initialize to non-zero state
    end else begin
        out <= {out[2:0], feedback};  // Shift left and insert feedback
    end
end

endmodule

// Testbench module for verification
module LFSR_tb;
    reg clk_tb;
    reg rst_tb;
    wire [3:0] out_tb;
    
    // Instantiate the LFSR
    LFSR dut (
        .clk(clk_tb),
        .rst(rst_tb),
        .out(out_tb)
    );
    
    // Clock generation
    initial begin
        clk_tb = 0;
        forever #5 clk_tb = ~clk_tb;
    end
    
    // Stimulus
    initial begin
        rst_tb = 1;
        #20 rst_tb = 0;
        #100 $finish;
    end
    
    // Monitoring
    initial begin
        $monitor("Time = %0t, out = %b", $time, out_tb);
    end
endmodule