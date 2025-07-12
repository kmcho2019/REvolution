module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] in_reg;
    
    always @(posedge clk) begin
        in_reg <= in;
    end
    
    // Detect 0->1 transition (in_reg was 0 and current in is 1)
    assign pedge = ~in_reg & in;

endmodule