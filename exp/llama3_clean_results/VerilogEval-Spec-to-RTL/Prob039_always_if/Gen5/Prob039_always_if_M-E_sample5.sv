module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output logic out_always
);

always @(*) begin
    case ({sel_b1, sel_b2})
        2'b11: begin
            out_assign = b;
            out_always = b;
        end
        default: begin
            out_assign = a;
            out_always = a;
        end
    endcase
end

endmodule