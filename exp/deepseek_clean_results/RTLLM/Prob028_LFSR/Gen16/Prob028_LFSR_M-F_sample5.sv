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

// Testbench
module LFSR_tb;
    reg clk_tb;
    reg rst_tb;
    wire [3:0] out_tb;
    
    // Instantiate LFSR
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
    
    // Test sequence
    initial begin
        // Initialize and reset
        rst_tb = 1;
        #10 rst_tb = 0;
        
        // Run for 20 clock cycles
        #200 $finish;
    end
    
    // Monitor output
    initial begin
        $monitor("Time=%0t, out=%4b", $time, out_tb);
    end
endmodule