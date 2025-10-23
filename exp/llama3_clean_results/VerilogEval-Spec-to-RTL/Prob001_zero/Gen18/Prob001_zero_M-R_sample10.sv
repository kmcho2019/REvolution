module TopModule (
    output zero
);
    reg zero_reg;
    always @(*) begin
        zero_reg = 1'b0;
    end
    assign zero = zero_reg;
endmodule