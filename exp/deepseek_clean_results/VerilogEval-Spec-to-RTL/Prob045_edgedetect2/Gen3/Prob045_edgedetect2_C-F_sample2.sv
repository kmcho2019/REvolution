module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        // Store previous input for edge detection
        prev_in <= in;
        
        // Any edge detection: XOR current with previous input
        // Outputs 1 for bits that changed between cycles
        anyedge <= in ^ prev_in;
    end

endmodule