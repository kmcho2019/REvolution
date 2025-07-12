module TopModule(
    input  [3:0] x,
    output      f
);

    // Function implementing the K-map logic with index {x[3], x[2], x[1], x[0]}:
    function automatic logic func(input [3:0] idx);
        begin
            case (idx)
                // Row=00 (x[3]x[2]=00)
                4'b0000: func = 1'b0; // d mapped to 0
                4'b0001: func = 1'b0;
                4'b0011: func = 1'b0; // d mapped to 0
                4'b0010: func = 1'b0; // d mapped to 0

                // Row=01 (x[3]x[2]=01)
                4'b0100: func = 1'b0;
                4'b0101: func = 1'b0; // d mapped to 0
                4'b0111: func = 1'b1;
                4'b0110: func = 1'b0;

                // Row=11 (x[3]x[2]=11)
                4'b1100: func = 1'b1;
                4'b1101: func = 1'b1;
                4'b1111: func = 1'b0; // d mapped to 0
                4'b1110: func = 1'b0; // d mapped to 0

                // Row=10 (x[3]x[2]=10)
                4'b1000: func = 1'b1;
                4'b1001: func = 1'b1;
                4'b1011: func = 1'b0; // d mapped to 0
                4'b1010: func = 1'b0; // d mapped to 0

                default: func = 1'b0;
            endcase
        end
    endfunction

    // Assign output 'f' directly via the function:
    assign f = func(x);

endmodule