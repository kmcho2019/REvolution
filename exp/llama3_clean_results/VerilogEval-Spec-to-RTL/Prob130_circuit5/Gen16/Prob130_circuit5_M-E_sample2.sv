module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

reg [3:0] sel;
reg def;

always_comb begin
    // Decoder for c[1:0]
    case (c[1:0])
        2'b00: sel = 1;
        2'b01: sel = 2;
        2'b10: sel = 3;
        2'b11: sel = 4;
    endcase
    
    // Default output value when c[3:2] != 2'b00
    def = (c[3:2] != 2'b00);
    
    // Multiplexer to select output
    case (sel)
        1: q = def ? 4'b1111 : b;
        2: q = def ? 4'b1111 : e;
        3: q = def ? 4'b1111 : a;
        4: q = def ? 4'b1111 : d;
    endcase
end

endmodule