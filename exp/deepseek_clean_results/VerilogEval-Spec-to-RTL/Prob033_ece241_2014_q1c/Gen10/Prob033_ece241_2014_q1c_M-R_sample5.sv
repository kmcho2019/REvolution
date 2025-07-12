module TopModule(
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] s,
    output overflow
);
    reg [7:0] carry;
    integer i;

    always @(*) begin
        carry[0] = a[0] & b[0];
        s[0] = a[0] ^ b[0];
        
        for (i = 1; i < 8; i = i + 1) begin
            carry[i] = (a[i] & b[i]) | ((a[i] ^ b[i]) & carry[i-1]);
            s[i] = a[i] ^ b[i] ^ carry[i-1];
        end
    end

    assign overflow = (a[7] == b[7]) && (s[7] != a[7]);
endmodule