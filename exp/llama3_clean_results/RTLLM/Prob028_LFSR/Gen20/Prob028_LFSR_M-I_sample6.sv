// Improved LFSR module
module LFSR(
    input           clk,       // Clock signal
    input           rst,       // Active high reset signal
    output reg [3:0] out       // 4-bit output representing the current state of the LFSR
);

// Sequential logic block to update the LFSR state
always @(posedge clk or posedge rst) begin
    if (rst) begin // Reset condition: initialize output to zero
        out <= 4'b0;
    end else begin // Normal operation: update LFSR state
        // Calculate feedback by XORing MSB and second MSB, and insert at LSB
        out <= {out[2:0], out[3] ^ out[2]};
    end
end

endmodule

// Improved Testbench for the LFSR module
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
        clk = 1'b0;
        forever begin
            #5; // Clock period is 10 units (5 for high, 5 for low)
            clk = ~clk;
        end
    end

    // Test sequence
    initial begin
        rst = 1'b1; // Start with reset high
        #10;        // Hold reset high for a clock cycle
        rst = 1'b0; // Release reset
        #100;       // Run for 100 time units
        $finish;
    end

    // Optional: Add initial values to improve PPA
    initial begin
        $dumpvars();
        $dumpfile("lfsr_dump.vcd");
    end

endmodule