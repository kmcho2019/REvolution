module LFSR #(
    parameter WIDTH = 4,              // Configurable width
    parameter INIT_VALUE = 4'b0001    // Non-zero initial value
)(
    input wire clk,                   // Clock input
    input wire rst,                   // Synchronous reset
    output reg [WIDTH-1:0] out        // LFSR state output
);

// Feedback calculation (XNOR of two MSBs)
wire feedback;
assign feedback = out[WIDTH-1] ~^ out[WIDTH-2];

always @(posedge clk) begin
    if (rst) begin
        out <= INIT_VALUE;           // Synchronous reset to initial value
    end
    else begin
        out <= {out[WIDTH-2:0], feedback};  // Shift left and insert feedback
    end
end

endmodule


/* Recommended Testbench Structure:
module tb_LFSR();
    reg clk = 0;
    reg rst = 1;
    wire [3:0] out;
    
    LFSR dut (.clk(clk), .rst(rst), .out(out));
    
    initial begin
        #10 rst = 0;
        #200 $finish;
    end
    
    always #5 clk = ~clk;
endmodule
*/