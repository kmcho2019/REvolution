module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] in_delayed;
    
    always @(posedge clk) begin
        in_delayed <= in;
    end

    // Positive edge detection:
    // XOR finds changed bits, AND with current input selects only 0->1 transitions
    assign pedge = (in ^ in_delayed) & in;

endmodule