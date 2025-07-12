module TopModule (
    input in1,
    input in2,
    output reg out
);

    always @(*) begin
        if (in1 == 1'b0 && in2 == 1'b0)
            out = 1'b1;
        else
            out = 1'b0;
    end

endmodule