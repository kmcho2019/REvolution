module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // Register to store input value from previous clock cycle
    reg [7:0] prev_in;

    always @(posedge clk) begin
        // Edge detection: XOR current input with previous input
        // Results in '1' for bits that changed, '0' for unchanged bits
        anyedge <= in ^ prev_in;
        
        // Store current input for next cycle comparison
        prev_in <= in;
    end

endmodule