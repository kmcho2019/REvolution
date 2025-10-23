module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output out_always
);

// Using assign statement to implement the 2-to-1 mux
assign out_assign = (sel_b1 && sel_b2) ? b : a;

// Using always block to implement the 2-to-1 mux
always @(a, b, sel_b1, sel_b2) begin
    if (sel_b1 && sel_b2) begin
        out_always = b;
    end else begin
        out_always = a;
    end
end

endmodule