module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

wire mux_val;

assign mux_val = (sel_b1 & sel_b2) ? b : a;

always @(*) begin
    case ({sel_b1, sel_b2})
        2'b11: out_always = b;
        default: out_always = a;
    endcase
end

assign out_assign = mux_val;

endmodule