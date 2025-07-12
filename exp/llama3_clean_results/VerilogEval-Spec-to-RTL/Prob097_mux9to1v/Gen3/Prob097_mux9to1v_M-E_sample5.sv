module TopModule(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    input [15:0] d,
    input [15:0] e,
    input [15:0] f,
    input [15:0] g,
    input [15:0] h,
    input [15:0] i,
    input [3:0] sel,
    output reg [15:0] out
);

reg [15:0] en_a, en_b, en_c, en_d, en_e, en_f, en_g, en_h, en_i;
reg [15:0] mask;

always @(*)
begin
    // Decode select signal into enable signals
    en_a = (sel == 4'b0000) ? 16'hffff : 16'h0000;
    en_b = (sel == 4'b0001) ? 16'hffff : 16'h0000;
    en_c = (sel == 4'b0010) ? 16'hffff : 16'h0000;
    en_d = (sel == 4'b0011) ? 16'hffff : 16'h0000;
    en_e = (sel == 4'b0100) ? 16'hffff : 16'h0000;
    en_f = (sel == 4'b0101) ? 16'hffff : 16'h0000;
    en_g = (sel == 4'b0110) ? 16'hffff : 16'h0000;
    en_h = (sel == 4'b0111) ? 16'hffff : 16'h0000;
    en_i = (sel == 4'b1000) ? 16'hffff : 16'h0000;

    // Generate mask for unused cases
    mask = ~(en_a | en_b | en_c | en_d | en_e | en_f | en_g | en_h | en_i);

    // Select desired input signal using bitwise OR operations
    out = (a & en_a) | (b & en_b) | (c & en_c) | (d & en_d) | (e & en_e) | (f & en_f) | (g & en_g) | (h & en_h) | (i & en_i) | (16'hffff & mask);
end

endmodule