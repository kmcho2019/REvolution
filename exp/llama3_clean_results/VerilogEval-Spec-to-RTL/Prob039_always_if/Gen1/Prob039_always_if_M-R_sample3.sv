module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always // Declare out_always as reg for procedural assignment
);

// Continuous assignment
assign out_assign = (sel_b1 && sel_b2) ? b : a;

// Procedural assignment
always @(*) begin
    out_always = out_assign; // Assign out_assign's value to out_always
end

endmodule