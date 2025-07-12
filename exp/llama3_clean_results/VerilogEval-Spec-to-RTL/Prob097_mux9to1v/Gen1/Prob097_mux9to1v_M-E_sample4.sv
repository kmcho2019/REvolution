module TopModule(
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output reg [15:0] out
);

reg [15:0] en_a, en_b, en_c, en_d, en_e, en_f, en_g, en_h, en_i;

always @(*)
begin
    en_a = (sel == 4'd0)? 16'd1 : 16'd0;
    en_b = (sel == 4'd1)? 16'd1 : 16'd0;
    en_c = (sel == 4'd2)? 16'd1 : 16'd0;
    en_d = (sel == 4'd3)? 16'd1 : 16'd0;
    en_e = (sel == 4'd4)? 16'd1 : 16'd0;
    en_f = (sel == 4'd5)? 16'd1 : 16'd0;
    en_g = (sel == 4'd6)? 16'd1 : 16'd0;
    en_h = (sel == 4'd7)? 16'd1 : 16'd0;
    en_i = (sel == 4'd8)? 16'd1 : 16'd0;

    out = (en_a & a) | (en_b & b) | (en_c & c) | (en_d & d) | (en_e & e) | (en_f & f) | (en_g & g) | (en_h & h) | (en_i & i);
    if (!(en_a | en_b | en_c | en_d | en_e | en_f | en_g | en_h | en_i))
        out = 16'd65535;
end

endmodule