// Define the top module
module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

// Use a single always block to implement both assign and procedural logic
always @(*) begin
    out_assign = (sel_b1 && sel_b2) ? b : a;
    out_always = (sel_b1 && sel_b2) ? b : a;
end

endmodule