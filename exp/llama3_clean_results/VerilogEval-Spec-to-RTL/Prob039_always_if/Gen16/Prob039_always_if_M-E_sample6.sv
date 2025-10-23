module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output logic out_always
);

logic mode;

always @(*) begin
    casez ({sel_b1, sel_b2})
        2'b11: out_always = b;
        default: out_always = a;
    endcase
    
    if (mode) begin
        out_assign = out_always;
    end else begin
        out_assign = (sel_b1 && sel_b2) ? b : a;
    end
end

endmodule