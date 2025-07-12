module TopModule (
    input  wire x,
    input  wire y,
    output reg  z
);

    always @(*) begin
        reg xor_val;
        xor_val = x ^ y;
        z = xor_val & x;
    end

endmodule