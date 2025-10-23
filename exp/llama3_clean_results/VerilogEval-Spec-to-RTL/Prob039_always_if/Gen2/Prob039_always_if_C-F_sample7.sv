module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output wire out_assign,
    output logic out_always
);

// Continuous assignment
assign out_assign = (sel_b1 && sel_b2) ? b : a;

// Procedural assignment using case statement
always @(*) begin
    case ({sel_b1, sel_b2})
        2'b11: out_always = b;
        default: out_always = a;
    endcase
end

endmodule