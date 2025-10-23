module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't care, ignored
    output reg out
);

// Combine inputs into a 3-bit selector: c as MSB, then b, then a as LSB
wire [2:0] sel = {c, b, a};

always @(*) begin
    case (sel)
        3'b000: out = 1'b0; // c=0,b=0,a=0 -> K-map: 0 (d=0 chosen)
        3'b001: out = 1'b1; // c=0,b=0,a=1 -> 1
        3'b010: out = 1'b1; // c=0,b=1,a=0 -> 1
        3'b011: out = 1'b0; // c=0,b=1,a=1 -> 0
        3'b100: out = 1'b0; // c=1,b=0,a=0 -> 0
        3'b101: out = 1'b1; // c=1,b=0,a=1 -> 1
        3'b110: out = 1'b1; // c=1,b=1,a=0 -> 1
        3'b111: out = 1'b1; // c=1,b=1,a=1 -> 1
        default: out = 1'b0; // default safe value
    endcase
end

endmodule