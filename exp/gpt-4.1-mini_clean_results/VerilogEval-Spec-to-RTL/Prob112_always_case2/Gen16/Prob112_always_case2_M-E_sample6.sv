module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

function [1:0] encode_pos;
    input [3:0] in_val;
    begin
        if (in_val[0])       encode_pos = 2'd0;
        else if (in_val[1])  encode_pos = 2'd1;
        else if (in_val[2])  encode_pos = 2'd2;
        else if (in_val[3])  encode_pos = 2'd3;
        else                 encode_pos = 2'd0;
    end
endfunction

assign pos = encode_pos(in);

endmodule