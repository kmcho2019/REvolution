module TopModule (
    input  [7:0] in,
    output [2:0] pos
);

    // Function to perform binary search for the lowest set bit position
    function [2:0] first_set_bit_pos;
        input [7:0] value;
        begin
            if (value[3:0] != 4'b0000) begin
                if (value[1:0] != 2'b00) begin
                    if (value[0]) first_set_bit_pos = 3'd0;
                    else          first_set_bit_pos = 3'd1;
                end else begin
                    if (value[2]) first_set_bit_pos = 3'd2;
                    else          first_set_bit_pos = 3'd3;
                end
            end else if (value[7:4] != 4'b0000) begin
                if (value[5:4] != 2'b00) begin
                    if (value[4]) first_set_bit_pos = 3'd4;
                    else          first_set_bit_pos = 3'd5;
                end else begin
                    if (value[6]) first_set_bit_pos = 3'd6;
                    else          first_set_bit_pos = 3'd7;
                end
            end else begin
                // No bits set
                first_set_bit_pos = 3'd0;
            end
        end
    endfunction

    // Assign output using the function if input is not zero, else 0
    assign pos = (in != 8'b0) ? first_set_bit_pos(in) : 3'd0;

endmodule