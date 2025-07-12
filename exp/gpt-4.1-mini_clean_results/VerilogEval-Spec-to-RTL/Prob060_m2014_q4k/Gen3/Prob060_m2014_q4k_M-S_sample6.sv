module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);
    reg [3:0] shift_reg;

    always @(posedge clk) 
        shift_reg <= resetn ? {shift_reg[2:0], in} : 4'b0;

    assign out = shift_reg[3];
endmodule