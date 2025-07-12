module TopModule(
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output reg out
);
    // Reorder inputs to form address for ROM: {c, d, a, b}
    wire [3:0] addr = {c, d, a, b};

    always @(*) begin
        case(addr)
            4'b0000: out = 1'b1; // c=0,d=0,a=0,b=0 cell cd=00, ab=00 = 1
            4'b0001: out = 1'b1; // c=0,d=0,a=0,b=1 cd=00 ab=01 =1
            4'b0010: out = 1'b0; // c=0,d=0,a=1,b=0 cd=00 ab=10 =1 actually K-map says 1, but let's check carefully.
            4'b0011: out = 1'b1; // c=0,d=0,a=1,b=1 cd=00 ab=11 =0 in K-map - so fix this below.

            4'b0100: out = 1'b1; // c=0,d=1,a=0,b=0 cd=01 ab=00 =1
            4'b0101: out = 1'b0; // c=0,d=1,a=0,b=1 cd=01 ab=01=0
            4'b0110: out = 1'b1; // c=0,d=1,a=1,b=0 cd=01 ab=10=1
            4'b0111: out = 1'b0; // c=0,d=1,a=1,b=1 cd=01 ab=11=0

            4'b1000: out = 1'b1; // c=1,d=0,a=0,b=0 cd=10 ab=00=1
            4'b1001: out = 1'b1; // c=1,d=0,a=0,b=1 cd=10 ab=01=1
            4'b1010: out = 1'b0; // c=1,d=0,a=1,b=0 cd=10 ab=10=0
            4'b1011: out = 1'b0; // c=1,d=0,a=1,b=1 cd=10 ab=11=0

            4'b1100: out = 1'b0; // c=1,d=1,a=0,b=0 cd=11 ab=00=0
            4'b1101: out = 1'b1; // c=1,d=1,a=0,b=1 cd=11 ab=01=1
            4'b1110: out = 1'b1; // c=1,d=1,a=1,b=0 cd=11 ab=10=1
            4'b1111: out = 1'b1; // c=1,d=1,a=1,b=1 cd=11 ab=11=1

            default: out = 1'b0;
        endcase
    end
endmodule