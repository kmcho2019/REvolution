module TopModule (
    input  [7:0] in,
    output [2:0] pos
);
    wire [3:0] lower_half = in[3:0];
    wire [3:0] upper_half = in[7:4];

    wire upper_any = |upper_half;
    wire lower_any = |lower_half;

    wire [1:0] lower_pos;
    wire [1:0] upper_pos;

    // Priority encoder for 4-bit input, outputs position of first '1' or zero if none
    function [1:0] pri4;
        input [3:0] val;
        begin
            pri4 = (val[0]) ? 2'd0 :
                   (val[1]) ? 2'd1 :
                   (val[2]) ? 2'd2 :
                   (val[3]) ? 2'd3 : 2'd0;
        end
    endfunction

    assign lower_pos = pri4(lower_half);
    assign upper_pos = pri4(upper_half);

    assign pos = (|in) ? {upper_any, upper_any ? upper_pos : lower_pos} : 3'd0;

endmodule