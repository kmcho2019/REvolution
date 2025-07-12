module TopModule (
    input  [7:0] in,
    output reg [2:0] pos
);

    // Function to return the index of the least significant set bit using casez for one-hot matching
    function [2:0] first_set_bit_pos;
        input [7:0] value;
        begin
            casex (value)
                8'bxxxxxxx1: first_set_bit_pos = 3'd0;
                8'bxxxxxx10: first_set_bit_pos = 3'd1;
                8'bxxxxx100: first_set_bit_pos = 3'd2;
                8'bxxxx1000: first_set_bit_pos = 3'd3;
                8'bxxx10000: first_set_bit_pos = 3'd4;
                8'bxx100000: first_set_bit_pos = 3'd5;
                8'bx1000000: first_set_bit_pos = 3'd6;
                8'b10000000: first_set_bit_pos = 3'd7;
                default:     first_set_bit_pos = 3'd0;  // no bits set
            endcase
        end
    endfunction

    always @(*) begin
        if (in != 8'b0)
            pos = first_set_bit_pos(in);
        else
            pos = 3'd0;
    end

endmodule