module TopModule (
    input  wire a,
    input  wire b,
    output reg  out
);
    reg xor_res;

    always @(*) begin
        xor_res = a ^ b;
        out = ~xor_res;
    end
endmodule