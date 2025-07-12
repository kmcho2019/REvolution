module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

// Feedback calculation using continuous assignment
wire feedback;
assign feedback = ~(out[3] ^ out[2]);

// Sequential logic with synchronous reset
always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001;  // Non-zero initial state
    end
    else begin
        out <= {out[2:0], feedback};  // Shift left and insert feedback
    end
end

endmodule

module LFSR_tb;

// Testbench signals
reg clk;
reg rst;
wire [3:0] out;

// Instantiate DUT with correct port mapping
LFSR dut (
    .clk(clk),
    .rst(rst),
    .out(out)
);

// Clock generation (100MHz)
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Stimulus and monitoring
initial begin
    rst = 1'b1;  // Assert reset
    $monitor("Time=%0t rst=%b out=%4b", $time, rst, out);
    
    #20 rst = 1'b0;  // Release reset
    
    // Run for 32 cycles to see complete sequence
    #320 $display("Simulation complete");
    $finish;
end

endmodule