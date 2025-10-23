module LFSR #(parameter WIDTH = 4) (
    input clk,
    input rst,
    output reg [WIDTH-1:0] out
);

// Continuous feedback calculation
wire feedback;
assign feedback = ~(out[WIDTH-1] ^ out[WIDTH-2]);

// Next state calculation
wire [WIDTH-1:0] next_out;
assign next_out = rst ? {{(WIDTH-1){1'b0}}, 1'b1} : 
                  {out[WIDTH-2:0], feedback};

// Sequential update
always @(posedge clk) begin
    out <= next_out;
end

endmodule

module LFSR_tb;

// Testbench signals
reg clk;
reg rst;
wire [3:0] out;

// Instantiate DUT
LFSR #(4) dut (
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
    
    #15 rst = 1'b0;  // Release reset after 15ns
    
    // Run for enough cycles to see complete sequence (15 for 4-bit LFSR)
    #160 begin
        $display("Complete sequence observed");
        $finish;
    end
end

// Sequence checker
reg [3:0] prev_out;
always @(posedge clk) begin
    if (!rst) begin
        prev_out <= out;
        if (out == 4'b0001 && prev_out != 4'b0000) begin
            $display("Sequence repeated at time %0t", $time);
        end
    end
end

endmodule