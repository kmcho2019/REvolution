module TopModule (
    input  [7:0] in,
    output [2:0] pos
);

    // Recursive function performing binary search to find the first set bit
    function [2:0] first_set_bit_pos;
        input [7:0] value;
        reg [3:0] upper;
        reg [3:0] lower;
        reg [2:0] result_lower;
        reg [2:0] result_upper;
        begin
            if (value == 8'b0) begin
                first_set_bit_pos = 3'd0; // No bits set
            end else if (value[7:4] != 4'b0) begin
                upper = value[7:4];
                // Recursive call for upper half
                if (upper[3:2] != 2'b0) begin
                    if (upper[2]) first_set_bit_pos = 3'd6;
                    else          first_set_bit_pos = 3'd7;
                end else begin
                    if (upper[0]) first_set_bit_pos = 3'd4;
                    else          first_set_bit_pos = 3'd5;
                end
            end else begin
                lower = value[3:0];
                // Recursive call for lower half
                if (lower[1:0] != 2'b0) begin
                    if (lower[0]) first_set_bit_pos = 3'd0;
                    else          first_set_bit_pos = 3'd1;
                end else begin
                    if (lower[2]) first_set_bit_pos = 3'd2;
                    else          first_set_bit_pos = 3'd3;
                end
            end
        end
    endfunction

    // Output zero if no bits set, else use function
    assign pos = (in != 8'b0) ? first_set_bit_pos(in) : 3'd0;

endmodule