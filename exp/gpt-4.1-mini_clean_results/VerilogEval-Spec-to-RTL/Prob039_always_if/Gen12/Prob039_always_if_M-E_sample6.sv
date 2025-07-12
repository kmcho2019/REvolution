module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

function automatic logic mux_select;
    input logic a_in, b_in;
    input logic sel1, sel2;
    begin
        if (sel1 && sel2)
            mux_select = b_in;
        else
            mux_select = a_in;
    end
endfunction

assign out_assign = mux_select(a, b, sel_b1, sel_b2);

always @(*) begin
    out_always = mux_select(a, b, sel_b1, sel_b2);
end

endmodule