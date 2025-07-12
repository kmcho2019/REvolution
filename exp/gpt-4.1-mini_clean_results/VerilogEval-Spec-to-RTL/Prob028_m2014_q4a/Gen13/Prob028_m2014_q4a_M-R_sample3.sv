module TopModule(
    input d,
    input ena,
    output reg q
);

    always @(*) begin
        q = ena ? d : q;
    end

endmodule