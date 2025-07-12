module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    parameter WIDTH = 8;  // Configurable bus width
    
    // Previous input storage
    reg [WIDTH-1:0] prev_in;
    
    // Edge detection combinational logic
    wire [WIDTH-1:0] edge_detect = in ^ prev_in;
    
    // Sequential logic block
    always @(posedge clk) begin
        anyedge <= edge_detect;  // Register edge detection result
        prev_in <= in;          // Update input history
    end

endmodule