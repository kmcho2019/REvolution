module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output out_always
);

// Continuous assignment using a more LUT-friendly formulation
assign out_assign = (sel_b1 && sel_b2) ? b : a;

// Alternatively, for out_always, use a similar formulation but in a procedural block
always @(*) begin
    case ({sel_b1, sel_b2})
        2'b11: out_always = b;
        default: out_always = a;
    endcase
end

endmodule