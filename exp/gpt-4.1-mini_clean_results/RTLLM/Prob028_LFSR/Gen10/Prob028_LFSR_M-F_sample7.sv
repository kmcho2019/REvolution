// LFSR module (unchanged, as it was correct)
module LFSR (
    input  wire       clk,
    input  wire       rst,   // synchronous active-high reset
    output reg [3:0]  out
);

    wire feedback;
    assign feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst)
            out <= 4'b0000;
        else
            out <= {out[2:0], feedback};
    end

endmodule


// Simple testbench to drive the LFSR with proper signal declarations and connections
module tb_LFSR();

    reg clk;
    reg rst;
    wire [3:0] out;

    // Instantiate the LFSR
    LFSR dut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Test stimulus
    initial begin
        // Initialize signals
        rst = 1;
        #20;      // hold reset high for 2 clock cycles
        rst = 0;
        
        // Run LFSR for some cycles
        #100;
        
        // Apply reset again to verify synchronous reset behavior
        rst = 1;
        #10;
        rst = 0;
        
        #50;

        // Finish simulation
        $finish;
    end

    // Optional: display output changes
    initial begin
        $display("Time\tclk\trst\tout");
        $monitor("%0dns\t%b\t%b\t%04b", $time, clk, rst, out);
    end

endmodule