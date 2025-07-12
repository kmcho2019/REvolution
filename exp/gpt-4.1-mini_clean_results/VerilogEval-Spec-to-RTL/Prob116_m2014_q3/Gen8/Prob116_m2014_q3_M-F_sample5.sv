module TopModule(
    input  [3:0] x, // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output      f
);

    // Function implementing the K-map logic with index {x4, x3, x2, x1}:
    function automatic logic func(input [3:0] idx);
        begin
            // idx = {x4, x3, x2, x1}
            case (idx)
                // x4x3=00 row
                4'b0000: func = 1'b0; // d mapped to 0
                4'b0001: func = 1'b0;
                4'b0011: func = 1'b0; // d mapped to 0
                4'b0010: func = 1'b0; // d mapped to 0

                // x4x3=01 row
                4'b0100: func = 1'b0;
                4'b0101: func = 1'b0; // d mapped to 0
                4'b0111: func = 1'b1;
                4'b0110: func = 1'b0;

                // x4x3=11 row
                4'b1100: func = 1'b1;
                4'b1101: func = 1'b1;
                4'b1111: func = 1'b0; // d mapped to 0
                4'b1110: func = 1'b0; // d mapped to 0

                // x4x3=10 row
                4'b1000: func = 1'b1;
                4'b1001: func = 1'b1;
                4'b1011: func = 1'b0; // d mapped to 0
                4'b1010: func = 1'b0; // d mapped to 0

                default: func = 1'b0;
            endcase
        end
    endfunction

    // Assign output 'f' by reordering inputs to match Karnaugh map indexing:
    // index = {x[3], x[2], x[1], x[0]} = {x4, x3, x2, x1}
    assign f = func({x[3], x[2], x[1], x[0]});

endmodule