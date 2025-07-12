module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

parameter SEED = 4'b0001;  // Initial seed value

// Feedback calculation (XOR bits 3 and 2, then invert)
wire feedback = ~(out[3] ^ out[2]);

always @(posedge clk) begin
    if (rst) begin
        out <= SEED;
    end
    else begin
        out <= {out[2:0], feedback};
    end
end

endmodule

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
        $monitor("Time=%0t: out=%4b", $time, out);
        
        // Initial reset
        rst = 1;
        #20 rst = 0;
        
        // Run for full sequence (15 cycles for 4-bit LFSR)
        #160 $finish;
    end
endmodule