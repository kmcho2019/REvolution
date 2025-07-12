module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

// Function encapsulating the mux logic
function logic mux_func(input logic a_in, input logic b_in, input logic sel1, input logic sel2);
    begin
        if (sel1 & sel2)
            mux_func = b_in;
        else
            mux_func = a_in;
    end
endfunction

// Continuous assignment uses the function directly
assign out_assign = mux_func(a, b, sel_b1, sel_b2);

// Procedural block uses the same function inside for clarity
always @(*) begin
    out_always = mux_func(a, b, sel_b1, sel_b2);
end

endmodule