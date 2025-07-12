module TopModule (
    input  a,
    input  b,
    output reg out
);

    wire or_result;
    assign or_result = a | b;

    always @(*) begin
        out = ~or_result;
    end

endmodule