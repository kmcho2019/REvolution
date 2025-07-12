module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

// 4-bit LFSR with feedback from bits 3 and 2
// Generates pseudo-random sequence starting from 0001 after reset
always @(posedge clk) begin
    out <= rst ? 4'b0001 : {out[2:0], ~(out[3] ^ out[2])};
end

endmodule

// Testbench for verification
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
    
    // Stimulus
    initial begin
        rst_tb = 1;
        #20 rst_tb = 0;
        #100 $finish;
    end
    
    // Monitoring
    initial begin
        $monitor("Time=%0t rst=%b out=%4b", $time, rst_tb, out_tb);
    end
endmodule