module TopModule(a, b, q);
    input  logic a, b;
    output logic q;
    always @(*) begin
        q = a & b;
    end
endmodule