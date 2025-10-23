module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] p = a ^ b; // propagate
    wire [7:0] g = a & b; // generate
    wire [8:0] c;         // carry signals: c[0] = cin = 0

    // Carry-lookahead function for 8 bits
    function [8:0] calc_carries;
        input [7:0] p_in;
        input [7:0] g_in;
        input       cin_in;
        integer i;
        reg [8:0] c_temp;
        begin
            c_temp[0] = cin_in;
            for (i = 0; i < 8; i = i + 1) begin
                c_temp[i+1] = g_in[i] | (p_in[i] & c_temp[i]);
            end
            calc_carries = c_temp;
        end
    endfunction

    assign c = calc_carries(p, g, 1'b0);
    assign s = p ^ c[7:0];
    assign overflow = c[7] ^ c[8]; // overflow = carry into MSB xor carry out MSB

endmodule