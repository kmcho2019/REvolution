module TopModule(
    input a,
    input b,
    input c,
    input d,
    output reg out
);
    always @(*) begin
        case ({a, b, c})
            3'b000: out = 0;  // ab=00, c=0
            3'b001: out = 1;  // ab=00, c=1
            3'b010: out = 0;  // ab=01, c=0
            3'b011: out = 0;  // ab=01, c=1 (d=0 chosen)
            3'b100: out = 1;  // ab=10, c=0
            3'b101: out = 1;  // ab=10, c=1
            3'b110: out = 1;  // ab=11, c=0
            3'b111: out = 1;  // ab=11, c=1
        endcase
    end
endmodule