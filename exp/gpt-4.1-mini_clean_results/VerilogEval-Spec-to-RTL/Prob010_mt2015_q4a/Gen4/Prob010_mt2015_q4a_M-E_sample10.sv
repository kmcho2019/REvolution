module TopModule (
    input  x,
    input  y,
    output reg z
);

    reg xor_result;
    reg and_result;

    always @(*) begin
        xor_result = x ^ y;
        and_result = xor_result & x;
        z = and_result;
    end

endmodule