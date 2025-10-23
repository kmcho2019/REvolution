module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

parameter SEED = 4'b0001;  // Initial seed value

always @(posedge clk) begin
    if (rst) begin
        out <= SEED;
    end
    else begin
        out <= {out[2:0], ~(out[3] ^ out[2])};
    end
end

endmodule

module LFSR_tb;
    reg clk = 0;
    reg rst = 1;
    wire [3:0] out;

    LFSR dut (.clk(clk), .rst(rst), .out(out));

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $monitor("At time %0t: out = %b", $time, out);
        
        // Initialize and reset
        #10 rst = 0;
        
        // Run for enough cycles to observe sequence
        #160 $finish;
    end
endmodule