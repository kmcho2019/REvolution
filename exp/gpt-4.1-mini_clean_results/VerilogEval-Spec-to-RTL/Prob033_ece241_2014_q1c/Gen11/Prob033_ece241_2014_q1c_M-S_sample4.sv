module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output reg [7:0] s,
    output overflow
);
    reg [8:0] carry; // carry[0] = initial carry-in (0), carry[8] = carry out of MSB

    integer i;

    always @(*) begin
        carry[0] = 1'b0;
        for (i = 0; i < 8; i = i + 1) begin
            s[i] = a[i] ^ b[i] ^ carry[i];
            carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    end

    // Overflow for signed addition: carry into MSB ^ carry out of MSB
    assign overflow = carry[7] ^ carry[8];

endmodule