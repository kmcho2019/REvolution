module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    // Local function to compute carry chain using carry-lookahead logic with generate loop
    function [8:0] calc_carries;
        input [7:0] p_in;
        input [7:0] g_in;
        input       cin_in;
        integer     i;
        reg [8:0]   c_temp;
        begin
            c_temp[0] = cin_in;
            // generate loop for prefix carry computation
            for (i = 0; i < 8; i = i + 1) begin
                c_temp[i+1] = g_in[i] | (p_in[i] & c_temp[i]);
            end
            calc_carries = c_temp;
        end
    endfunction

    wire [7:0] p = a ^ b;    // propagate signals
    wire [7:0] g = a & b;    // generate signals
    wire [8:0] c;            // carry signals, c[0] = cin (0)

    assign c = calc_carries(p, g, 1'b0);
    assign s = p ^ c[7:0];
    // Overflow = carry into MSB XOR carry out of MSB
    assign overflow = c[7] ^ c[8];

endmodule