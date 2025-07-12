module TopModule(in, out);
    output out;
    input  in;
    reg out_reg;
    always @(*) begin
        out_reg = in;
    end
    assign out = out_reg;
endmodule