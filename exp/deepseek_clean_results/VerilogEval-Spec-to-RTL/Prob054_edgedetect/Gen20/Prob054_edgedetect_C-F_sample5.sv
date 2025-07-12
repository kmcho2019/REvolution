module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    parameter WIDTH = 8;  // Configurable width for flexibility
    reg [WIDTH-1:0] prev_in;
    
    // Single register for edge detection
    always @(posedge clk) begin
        prev_in <= in;
    end
    
    // Efficient edge detection: 0 in previous cycle, 1 in current cycle
    assign pedge = ~prev_in & in;

endmodule