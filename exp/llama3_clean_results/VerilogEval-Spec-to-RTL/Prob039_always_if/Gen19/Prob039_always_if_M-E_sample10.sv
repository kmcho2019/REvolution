module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output logic out_always
);

// Direct assignment using LUT
assign out_assign = (sel_b1 && sel_b2) ? b : a;

// Procedural assignment using LUT
always @(*) begin
    case ({sel_b1, sel_b2})
        2'b00: out_always = a;
        2'b01: out_always = a;
        2'b10: out_always = a;
        2'b11: out_always = b;
        default: out_always = a;
    endcase
end

// Alternative implementation using a single always block
// logic out;
// always @(*) begin
//     case ({sel_b1, sel_b2})
//         2'b00: out = a;
//         2'b01: out = a;
//         2'b10: out = a;
//         2'b11: out = b;
//         default: out = a;
//     endcase
//     assign out_assign = out;
//     out_always = out;
// end

endmodule