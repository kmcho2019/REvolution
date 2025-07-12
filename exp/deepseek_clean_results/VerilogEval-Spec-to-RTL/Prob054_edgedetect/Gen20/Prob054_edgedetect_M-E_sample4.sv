module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] prev_in;
    
    always @(posedge clk) begin
        prev_in <= in;
    end
    
    // XOR finds changed bits, AND with current input finds 0->1 transitions
    assign pedge = (in ^ prev_in) & in;

endmodule