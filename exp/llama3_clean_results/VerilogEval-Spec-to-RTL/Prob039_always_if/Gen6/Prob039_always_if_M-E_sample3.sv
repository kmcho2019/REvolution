module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

// Implementing a mini-LUT concept for the 2-to-1 multiplexer
// For out_assign, using a more direct and explicit conditional statement
assign out_assign = (sel_b1 && sel_b2) ? b : a;

// For out_always, using a case statement to mimic a LUT
always @(*) begin
    case ({sel_b1, sel_b2})
        2'b11: out_always = b; // If both sel_b1 and sel_b2 are 1, choose b
        default: out_always = a; // Otherwise, choose a
    endcase
end

endmodule