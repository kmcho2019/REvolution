module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output reg f
);

always @(*) begin
    case ({x3, x2, x1})
        3'b010: f = 1'b1; // x3=0,x2=1,x1=0
        3'b011: f = 1'b1; // x3=0,x2=1,x1=1
        3'b101: f = 1'b1; // x3=1,x2=0,x1=1
        3'b111: f = 1'b1; // x3=1,x2=1,x1=1
        default: f = 1'b0;
    endcase
end

endmodule