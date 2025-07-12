module TopModule (
    input  a,
    input  b,
    output reg out
);

    wire xor_result;
    assign xor_result = a ^ b;

    always @(*) begin
        out = ~xor_result;
    end

endmodule