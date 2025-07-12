module TopModule (
    input in1,
    input in2,
    output reg out
);
    reg or_result;

    always @(*) begin
        or_result = in1 | in2;
        out = ~or_result;
    end
endmodule