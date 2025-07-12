module TopModule(input in, output out);
    reg internal_out;
    assign out = internal_out;

    always @(*) begin
        internal_out = in;
    end
endmodule