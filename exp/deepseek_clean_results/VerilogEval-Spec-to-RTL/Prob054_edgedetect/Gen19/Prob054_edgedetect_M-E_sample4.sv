module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    // Single register to store previous value for each bit
    reg [7:0] prev_in;
    
    always @(posedge clk) begin
        prev_in <= in;
    end
    
    // Edge detection: 
    // 1. XOR detects any change (0->1 or 1->0)
    // 2. AND with current value ensures we only catch 0->1 transitions
    assign pedge = (in ^ prev_in) & in;

endmodule