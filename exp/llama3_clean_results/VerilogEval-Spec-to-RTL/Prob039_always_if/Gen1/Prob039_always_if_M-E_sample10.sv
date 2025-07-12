module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

// Using assign statement for combinational logic
assign out_assign = (sel_b1 && sel_b2) ? b : a;

// Using always block with case statement for procedural assignment
always @(*) begin
    case ({sel_b1, sel_b2})
        2'b11: out_always = b; // If both sel_b1 and sel_b2 are 1, select b
        default: out_always = a; // For all other cases, select a
    endcase
end

endmodule