module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // Previous input storage
    reg [7:0] prev_in;
    
    // Edge detection logic (XOR current with previous input)
    wire [7:0] edge_detect = in ^ prev_in;

    always @(posedge clk) begin
        // Output 1 for any bit that changed from previous cycle
        anyedge <= edge_detect;
        
        // Store current input for next cycle comparison
        prev_in <= in;
    end

endmodule