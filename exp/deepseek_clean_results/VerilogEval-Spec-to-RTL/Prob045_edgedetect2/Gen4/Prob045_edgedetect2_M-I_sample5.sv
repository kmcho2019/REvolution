module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        // Edge detection using XOR - most efficient method
        anyedge <= in ^ prev_in;
        
        // Store current input for next cycle comparison
        prev_in <= in;
    end

endmodule