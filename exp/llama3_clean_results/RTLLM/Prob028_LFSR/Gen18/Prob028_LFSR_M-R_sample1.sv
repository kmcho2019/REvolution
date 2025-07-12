// Refactored LFSR module
module LFSR(
    input           clk,       // Clock signal
    input           rst,       // Active high reset signal
    output reg [3:0] out       // 4-bit output representing the current state of the LFSR
);

// Stage 1: First 2 bits
reg [1:0] stage1;
// Stage 2: Last 2 bits
reg [1:0] stage2;

// Sequential logic block to update the LFSR state
always @(posedge clk or posedge rst) begin
    if (rst) begin // Reset condition: initialize output to zero
        stage1 <= 2'b0;
        stage2 <= 2'b0;
    end else begin // Normal operation: update LFSR state
        // Calculate intra-stage feedback
        stage1 <= {stage1[0], stage1[1] ^ stage1[0] ^ stage2[0]};
        stage2 <= {stage2[0], stage2[1] ^ stage2[0] ^ stage1[1]};
    end
end

// Combine stage outputs to form the final output
assign out = {stage1, stage2};

endmodule

// Testbench for the LFSR module
module LFSR_tb;
    reg clk;         // Clock signal
    reg rst;         // Reset signal
    wire [3:0] out;  // Output from the LFSR module

    // Instantiate the LFSR module
    LFSR lfsr_instance(
      .clk(clk),
      .rst(rst),
      .out(out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever begin
            #5; // Clock period is 10 units (5 for high, 5 for low)
            clk = ~clk;
        end
    end

    // Test sequence
    initial begin
        rst = 1; // Start with reset high
        #10;    // Hold reset high for a clock cycle
        rst = 0; // Release reset
        #100;   // Run for 100 time units
        $finish;
    end

endmodule