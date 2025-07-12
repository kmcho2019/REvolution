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
        2'b00: begin
            out_always <= a;
            out_assign = a;
        end
        2'b01: begin
            out_always <= a;
            out_assign = a;
        end
        2'b10: begin
            out_always <= a;
            out_assign = a;
        end
        2'b11: begin
            out_always <= b;
            out_assign = b;
        end
        default: begin
            out_always <= a;
            out_assign = a;
        end
    endcase
end

endmodule