module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    // State encoding:
    // A=000, B=001, C=010, D=011, E=100, F=101

    function automatic bit next_y1_bit(input [2:0] state, input w_in);
        begin
            case (state)
                3'b001: next_y1_bit = 1'b1;                          // B
                3'b010: next_y1_bit = w_in ? 1'b1 : 1'b0;           // C
                3'b100: next_y1_bit = w_in ? 1'b1 : 1'b0;           // E
                3'b101: next_y1_bit = 1'b1;                          // F
                default: next_y1_bit = 1'b0;                         // A, D and others
            endcase
        end
    endfunction

    assign Y1 = next_y1_bit(y, w);

endmodule