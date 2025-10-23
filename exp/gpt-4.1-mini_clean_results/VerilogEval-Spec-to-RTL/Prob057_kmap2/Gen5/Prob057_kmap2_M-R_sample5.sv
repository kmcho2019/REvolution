module TopModule(
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output reg out
);

always @(*) begin
    case ({c,d})
        2'b00: // cd=00
            // F_00 = ~a + ~b
            out = (~a) | (~b);
        2'b01: // cd=01
            // F_01 = ~b
            out = ~b;
        2'b11: // cd=11
            // F_11 = a + b
            out = a | b;
        2'b10: // cd=10
            // F_10 = ~a
            out = ~a;
        default:
            out = 1'b0; // fallback, should never occur
    endcase
end

endmodule