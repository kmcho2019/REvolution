// Define the top module with the required ports
module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output logic out_always
);

// Use continuous assignment to implement the multiplexer logic for out_assign
assign out_assign = (sel_b1 && sel_b2) ? b : a;

// Use an always_comb block to implement the same logic for out_always
always_comb begin
    out_always = (sel_b1 && sel_b2) ? b : a;
end

endmodule