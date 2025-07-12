module TopModule (
    input  in1,
    input  in2,
    output reg out
);
    always @(*) begin
        if (in1 == 0 && in2 == 0)
            out = 1;
        else
            out = 0;
    end
endmodule