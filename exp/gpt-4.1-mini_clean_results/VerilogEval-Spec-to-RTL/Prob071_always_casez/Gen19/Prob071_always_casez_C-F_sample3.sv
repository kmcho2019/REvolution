module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    // Recursive function performing binary search priority encoding
    function [2:0] priority_encode_8;
        input [7:0] bits;
        begin
            if (bits[3:0] != 4'b0000) begin
                if (bits[1:0] != 2'b00) begin
                    if (bits[0]) priority_encode_8 = 3'd0;
                    else        priority_encode_8 = 3'd1;
                end else begin
                    if (bits[2]) priority_encode_8 = 3'd2;
                    else        priority_encode_8 = 3'd3;
                end
            end else if (bits[7:4] != 4'b0000) begin
                if (bits[5:4] != 2'b00) begin
                    if (bits[4]) priority_encode_8 = 3'd4;
                    else        priority_encode_8 = 3'd5;
                end else begin
                    if (bits[6]) priority_encode_8 = 3'd6;
                    else        priority_encode_8 = 3'd7;
                end
            end else begin
                priority_encode_8 = 3'd0;  // No bits set
            end
        end
    endfunction

    assign pos = priority_encode_8(in);

endmodule