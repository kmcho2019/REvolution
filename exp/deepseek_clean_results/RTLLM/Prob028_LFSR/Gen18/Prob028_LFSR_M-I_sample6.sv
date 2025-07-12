module LFSR #(parameter WIDTH = 4) (
    input clk,
    input rst,
    output reg [WIDTH-1:0] out
);

// Feedback calculation (XOR of two MSBs)
wire feedback;
assign feedback = out[WIDTH-1] ^ out[WIDTH-2];

always @(posedge clk) begin
    if (rst) begin
        out <= {{(WIDTH-1){1'b0}}, 1'b1}; // Non-zero init
    end
    else begin
        out <= {out[WIDTH-2:0], feedback}; // Shift and insert
    end
end

endmodule

module LFSR_tb;

// Testbench signals
reg clk_tb;
reg rst_tb;
wire [3:0] out_tb;

// Instantiate DUT with proper connections
LFSR #(4) dut (
    .clk(clk_tb),
    .rst(rst_tb),
    .out(out_tb)
);

// Clock generation (100MHz)
initial begin
    clk_tb = 0;
    forever #5 clk_tb = ~clk_tb;
end

// Stimulus and monitoring
initial begin
    rst_tb = 1'b1;  // Assert reset
    $monitor("Time=%0t rst=%b out=%4b", $time, rst_tb, out_tb);
    
    #15 rst_tb = 1'b0;  // Release reset after 15ns
    
    // Run for enough cycles to see complete sequence (15 for 4-bit LFSR)
    #160 begin
        $display("Complete sequence observed");
        $finish;
    end
end

// Sequence checker
reg [3:0] prev_out;
always @(posedge clk_tb) begin
    if (!rst_tb) begin
        prev_out <= out_tb;
        if (out_tb == 4'b0001 && prev_out != 4'b0000) begin
            $display("Sequence repeated at time %0t", $time);
        end
    end
end

endmodule