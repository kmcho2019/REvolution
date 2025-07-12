module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    // Localparam concatenating the inputs in order: b(0), e(1), a(2), d(3), 4'hF(4)
    localparam [19:0] DATA_VEC = {4'hF, d, a, e, b};

    // Combinational function to select 4-bit slice with c clamped at 4
    function [3:0] select_q;
        input [3:0] c_sel;
        reg [2:0] idx;
        begin
            idx = (c_sel < 5) ? c_sel[2:0] : 3'd4; // Clamp c to 4
            // Extract the selected 4-bit nibble by shifting right by (idx << 2)
            select_q = (DATA_VEC >> (idx << 2)) & 4'hF;
        end
    endfunction

    assign q = select_q(c);

endmodule