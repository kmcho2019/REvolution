module TopModule (
    output one
);
    reg internal_one;

    initial begin
        internal_one = 1'b1;
    end

    always @(*) begin
        one = internal_one;
    end
endmodule