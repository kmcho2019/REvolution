module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

// Feedback calculation (XOR of bits 3 and 2, inverted)
wire feedback = ~(out[3] ^ out[2]);

// Next state logic
wire [3:0] next_out = {out[2:0], feedback};

// Register update
always @(posedge clk) begin
    out <= rst ? 4'b0001 : next_out;
end

endmodule

// Testbench for verification
module LFSR_tb;
    reg clk;
    reg rst;
    wire [3:0] out;
    
    // Instantiate DUT
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
    
    // Stimulus
    initial begin
        rst = 1;
        #20 rst = 0;
        #100 $finish;
    end
    
    // Monitoring
    initial begin
        $monitor("Time=%0t rst=%b out=%4b", $time, rst, out);
    end
endmodule