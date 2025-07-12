module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] prev_in;
    
    always @(posedge clk) begin
        prev_in <= in;
    end
    
    // Detect 0->1 transitions: 0 in previous cycle and 1 in current
    assign pedge = ~prev_in & in;

endmodule