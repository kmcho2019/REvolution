module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;  // Stores input from previous cycle
    
    // Combinational edge detection
    wire [7:0] edge_detect = in ^ prev_in;

    always @(posedge clk) begin
        anyedge <= edge_detect;  // Register edge detection results
        prev_in <= in;           // Store current input for next cycle
    end

endmodule