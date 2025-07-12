module TopModule(
    input a,
    input b,
    input c,
    input d,
    output reg out
);
    always @(*) begin
        case ({a,b,c})
            3'b000: out = 0;  // cd=00, ab=00
            3'b001: out = 0;  // cd=01, ab=00
            3'b010: out = 1;  // cd=10, ab=00
            3'b011: out = 1;  // cd=11, ab=00
            3'b100: out = 0;  // cd=00, ab=01
            3'b101: out = 0;  // cd=01, ab=01
            3'b110: out = 1;  // cd=10, ab=01 (don't-care optimized to 1)
            3'b111: out = 1;  // cd=11, ab=01 (don't-care optimized to 1)
        endcase
    end
endmodule