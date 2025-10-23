module TopModule (
    input  [7:0] in,
    output [2:0] pos
);
    // Encode position of the first set bit in a 4-bit input,
    // or 0 if none set.
    function [1:0] enc4;
        input [3:0] x;
        begin
            enc4 = (x[0]) ? 2'd0 :
                   (x[1]) ? 2'd1 :
                   (x[2]) ? 2'd2 :
                   (x[3]) ? 2'd3 : 2'd0;
        end
    endfunction

    wire [1:0] pos_low  = enc4(in[3:0]);
    wire [1:0] pos_high = enc4(in[7:4]);
    wire       high_set = |in[7:4];
    wire       low_set  = |in[3:0];

    assign pos = low_set ? {1'b0, pos_low} :
                 high_set ? {1'b1, pos_high} :
                            3'd0;

endmodule