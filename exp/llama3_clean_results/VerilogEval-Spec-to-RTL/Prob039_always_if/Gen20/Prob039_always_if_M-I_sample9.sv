// Define the top module
module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output logic out_always
);

// Use a single assign statement to reduce logic complexity
assign out_assign = (sel_b1 && sel_b2)? b : a;

// Use a single always block to reduce logic complexity
always @(*) begin
    out_always = (sel_b1 && sel_b2)? b : a;
end

endmodule