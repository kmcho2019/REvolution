module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);

wire [1:0] sel = {x3, x2};
reg f_reg;

always @(*) begin
    case (sel)
        2'b00: f_reg = 1'b0;      // x3=0, x2=0 -> f=0
        2'b01: f_reg = 1'b1;      // x3=0, x2=1 -> f=1
        2'b10: f_reg = x1;        // x3=1, x2=0 -> f=x1
        2'b11: f_reg = x1;        // x3=1, x2=1 -> f=x1 (as per truth table, only 111=1)
        default: f_reg = 1'b0;
    endcase
end

assign f = f_reg;

endmodule