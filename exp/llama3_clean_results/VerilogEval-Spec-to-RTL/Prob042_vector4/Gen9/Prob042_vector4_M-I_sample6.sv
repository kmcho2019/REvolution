module TopModule(
    input  [7:0] in,
    output [31:0] out
);
    // Ensuring input and output are properly synchronized
    reg [7:0] in_reg;
    always @(posedge clk) begin
        in_reg <= in;
    end
    
    // Using the synchronized input for sign extension
    assign out = { {24{in_reg[7]}}, in_reg };
endmodule