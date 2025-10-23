module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

wire feedback;
assign feedback = out[3] ~^ out[2];  // XNOR feedback

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

reg clk_tb;
reg rst_tb;
wire [3:0] out_tb;

// Instantiate DUT
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

// Stimulus and verification
initial begin
    rst_tb = 1;
    #20 rst_tb = 0;
    
    // Monitor LFSR output
    $monitor("Time = %0t, out = %b", $time, out_tb);
    
    // Run for 32 cycles to observe sequence
    #160;
    
    // Check for all-zeros state (should never occur)
    if (out_tb == 4'b0000) begin
        $display("ERROR: LFSR entered all-zeros state!");
    end
    
    $finish;
end

endmodule