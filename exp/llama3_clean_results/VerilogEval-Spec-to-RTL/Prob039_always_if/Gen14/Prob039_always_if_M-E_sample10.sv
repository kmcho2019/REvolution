module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output logic out_assign,
    output logic out_always
);

always @(*) begin
    logic temp_out;
    temp_out = (sel_b1 && sel_b2)? b : a;
    out_assign = temp_out;
    out_always = temp_out;
end

endmodule