// Simplified LFSR module
module LFSR (
    input           clk,       // Clock signal
    input           rst,       // Active high reset signal
    output reg [3:0] out  // Output representing the current state of the LFSR
);

// Always block for sequential logic
always @(posedge clk) begin
    if (rst) begin // Reset condition: initialize state to zero
        out <= 4'b0;
    end else begin // Normal operation: update LFSR state
        // Shift the bits in the LFSR and insert the new feedback value
        out <= {out[2:0], out[3] ^ out[2]};
    end
end

endmodule

// Simplified testbench for LFSR
module LFSR_testbench;
    reg clk = 0;
    reg rst = 1;
    wire [3:0] out;

    // Instantiate the LFSR module
    LFSR lfsr_inst (
       .clk(clk),
       .rst(rst),
       .out(out)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Reset assertion
    initial #10 rst = 0;

    // Monitor output
    initial begin
        $display("Time = %0d, out = %b", $time, out);
        forever #10 $display("Time = %0d, out = %b", $time, out);
    end

    // Verification
    initial begin
        #100;
        $display("Verification: Expected sequence length is 15 for a 4-bit LFSR.");
        $finish;
    end

endmodule