module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;  // Stores previous input for edge detection

    always @(posedge clk) begin
        // Edge detection: XOR current and previous input values
        // Result is 1 for bits that changed, 0 for stable bits
        anyedge <= in ^ prev_in;
        
        // Store current input for next cycle comparison
        prev_in <= in;
    end

endmodule