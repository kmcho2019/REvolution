module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output reg out_assign,
    output reg out_always
);

// Combinational Logic using LUT concept
assign out_assign = (sel_b1 && sel_b2) ? b : a;

// Procedural Logic using LUT concept
always @(*) begin
    case ({sel_b1, sel_b2})
        2'b00: out_always <= a;
        2'b01: out_always <= a;
        2'b10: out_always <= a;
        2'b11: out_always <= b;
        default: out_always <= a;
    endcase
end

endmodule