module TopModule(a, b, out);
    output out;
    input a, b;
    reg out;

    always @(*) begin
        out = a & b;
    end
endmodule