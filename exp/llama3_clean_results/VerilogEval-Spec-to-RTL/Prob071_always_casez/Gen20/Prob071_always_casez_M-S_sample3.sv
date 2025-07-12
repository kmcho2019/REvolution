module TopModule(
    input  [7:0] in,  // 8-bit input
    output [2:0] pos   // 3-bit output
);

    integer i;
    reg [2:0] temp_pos;

    always @(*) begin
        temp_pos = 3'd0;  // Initialize pos to 0
        for (i = 0; i < 8; i = i + 1) begin
            if (in[i] == 1'b1) begin
                case (i)
                    0: temp_pos = 3'd0;
                    1: temp_pos = 3'd1;
                    2: temp_pos = 3'd2;
                    3: temp_pos = 3'd3;
                    4: temp_pos = 3'd4;
                    5: temp_pos = 3'd5;
                    6: temp_pos = 3'd6;
                    7: temp_pos = 3'd7;
                endcase
                break;  // Exit the loop once the first '1' bit is found
            end
        end
        pos = temp_pos;
    end

endmodule