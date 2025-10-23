module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    parameter WIDTH = 8;  // Configurable bus width
    
    // Stores previous cycle's input for edge detection
    reg [WIDTH-1:0] prev_in;

    always @(posedge clk) begin
        // Edge detection: XOR current with previous input
        // Sets bit to 1 when any transition (0->1 or 1->0) occurs
        anyedge <= in ^ prev_in;
        
        // Store current input for next cycle comparison
        prev_in <= in;
    end

endmodule