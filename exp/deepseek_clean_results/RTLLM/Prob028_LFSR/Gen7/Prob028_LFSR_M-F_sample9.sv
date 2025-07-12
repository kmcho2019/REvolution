module LFSR #(parameter WIDTH = 4) (
    input clk,
    input rst,
    output reg [WIDTH-1:0] out
);

// 4-bit LFSR with feedback from bits 3 and 2
always @(posedge clk or posedge rst)
    out <= rst ? {WIDTH{1'b0}} : {out[WIDTH-2:0], ~(out[WIDTH-1] ^ out[WIDTH-2])};

endmodule

module LFSR_tb;

// Testbench parameters
parameter WIDTH = 4;
parameter CLK_PERIOD = 10;

// Testbench signals
reg clk_tb;
reg rst_tb;
wire [WIDTH-1:0] out_tb;

// Instantiate DUT
LFSR #(.WIDTH(WIDTH)) dut (
    .clk(clk_tb),
    .rst(rst_tb),
    .out(out_tb)
);

// Clock generation
initial begin
    clk_tb = 0;
    forever #(CLK_PERIOD/2) clk_tb = ~clk_tb;
end

// Stimulus and verification
initial begin
    // Initialize
    rst_tb = 1;
    #20;
    
    // Release reset
    rst_tb = 0;
    
    // Monitor outputs
    $monitor("Time = %0t, out = %b", $time, out_tb);
    
    // Run for some cycles
    #(CLK_PERIOD * 20);
    
    // Verify non-zero output after reset
    if (out_tb === 4'b0000) begin
        $display("Error: Output stuck at zero after reset");
    end
    
    $finish;
end

endmodule