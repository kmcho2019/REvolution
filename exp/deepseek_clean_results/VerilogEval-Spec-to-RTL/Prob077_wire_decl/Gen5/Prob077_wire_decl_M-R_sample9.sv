module TopModule (
    input a,
    input b,
    input c,
    input d,
    output reg out,
    output out_n
);

    always @(*) begin
        out = (a & b) | (c & d);
    end

    assign out_n = ~out;

endmodule