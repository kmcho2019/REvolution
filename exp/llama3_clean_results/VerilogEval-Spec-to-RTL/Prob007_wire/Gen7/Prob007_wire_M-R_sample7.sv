module TopModule(in, out);
    output out;
    input  in;
    always @(in) begin
        out <= in;
    end
endmodule