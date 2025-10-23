module TopModule (
    input  wire x,
    input  wire y,
    output reg  z
);

    reg xor_result;

    always @(*) begin
        xor_result = x ^ y;
        z = xor_result & x;
    end

endmodule