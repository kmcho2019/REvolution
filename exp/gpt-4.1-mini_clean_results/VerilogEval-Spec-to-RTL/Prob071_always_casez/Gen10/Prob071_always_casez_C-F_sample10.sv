module TopModule (
    input  [7:0] in,
    output [2:0] pos
);

    // Function to encode the position of the first set bit (LSB priority).
    function [2:0] first_set_bit_pos;
        input [7:0] value;
        begin
            first_set_bit_pos = (value[0]) ? 3'd0 :
                                (value[1]) ? 3'd1 :
                                (value[2]) ? 3'd2 :
                                (value[3]) ? 3'd3 :
                                (value[4]) ? 3'd4 :
                                (value[5]) ? 3'd5 :
                                (value[6]) ? 3'd6 :
                                (value[7]) ? 3'd7 : 3'd0;
        end
    endfunction

    assign pos = first_set_bit_pos(in);

endmodule