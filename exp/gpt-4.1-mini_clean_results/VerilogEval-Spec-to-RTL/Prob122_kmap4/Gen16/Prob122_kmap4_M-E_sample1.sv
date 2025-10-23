module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);
    // Combine inputs into a 4-bit index: cdab
    wire [3:0] idx = {c, d, a, b};

    always @(*) begin
        case (idx)
            4'b0000: out = 0; // c=0,d=0,a=0,b=0 -> map(00,00)=0
            4'b0001: out = 1; // map(00,01)=1
            4'b0010: out = 1; // map(01,00)=1
            4'b0011: out = 0; // map(01,01)=0
            4'b0100: out = 1; // map(00,10)=1
            4'b0101: out = 0; // map(00,11)=0
            4'b0110: out = 0; // map(01,10)=0
            4'b0111: out = 1; // map(01,11)=1
            4'b1000: out = 0; // map(10,00)=0
            4'b1001: out = 1; // map(10,01)=1
            4'b1010: out = 1; // map(11,00)=1
            4'b1011: out = 0; // map(11,01)=0
            4'b1100: out = 1; // map(10,10)=1
            4'b1101: out = 0; // map(10,11)=0
            4'b1110: out = 0; // map(11,10)=0
            4'b1111: out = 1; // map(11,11)=1
            default: out = 0;
        endcase
    end
endmodule