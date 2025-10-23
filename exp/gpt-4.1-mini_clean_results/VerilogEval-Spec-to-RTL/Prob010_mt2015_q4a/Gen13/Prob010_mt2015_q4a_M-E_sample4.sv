module TopModule (
    input  x,
    input  y,
    output reg z
);

    reg xor_val;

    always @(*) begin
        xor_val = x ^ y;
        z = xor_val & x;
    end

endmodule