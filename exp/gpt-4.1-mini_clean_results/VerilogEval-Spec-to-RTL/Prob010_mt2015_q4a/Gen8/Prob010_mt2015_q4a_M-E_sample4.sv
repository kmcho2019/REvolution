module TopModule (
    input  wire x,
    input  wire y,
    output reg  z
);
    reg xor_xy;

    always @(*) begin
        xor_xy = x ^ y;
        z = xor_xy & x;
    end
endmodule