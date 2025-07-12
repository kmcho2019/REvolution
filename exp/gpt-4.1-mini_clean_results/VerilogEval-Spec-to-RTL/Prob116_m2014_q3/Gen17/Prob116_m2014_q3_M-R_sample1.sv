module TopModule (
    input  [3:0] x,  // x[3] = x4, x[2] = x3, x[1] = x2, x[0] = x1 (problem notation)
    output        f
);

    // Map input bits explicitly for clarity
    wire x1 = x[0]; // problem x[1]
    wire x2 = x[1]; // problem x[2]
    wire x3 = x[2]; // problem x[3]
    wire x4 = x[3]; // problem x[4]

    // Gray-to-binary conversion for row (x3,x4)
    wire row_gray1 = x3;
    wire row_gray0 = x4;
    wire row_bin1  = row_gray1;
    wire row_bin0  = row_gray1 ^ row_gray0;

    // Gray-to-binary conversion for column (x1,x2)
    wire col_gray1 = x1;
    wire col_gray0 = x2;
    wire col_bin1  = col_gray1;
    wire col_bin0  = col_gray1 ^ col_gray0;

    // Combine decoded row and column to form address
    wire [3:0] addr = {row_bin1, row_bin0, col_bin1, col_bin0};

    // Function that returns f value based on addr using Karnaugh map with don't-cares as 0
    function automatic logic map_function(input [3:0] addr_in);
        begin
            case (addr_in)
                4'b0000: map_function = 1'b0; // d -> 0
                4'b0001: map_function = 1'b0; // 0
                4'b0010: map_function = 1'b0; // d -> 0
                4'b0011: map_function = 1'b0; // d -> 0

                4'b0100: map_function = 1'b0; // 0
                4'b0101: map_function = 1'b0; // d -> 0
                4'b0110: map_function = 1'b1; // 1
                4'b0111: map_function = 1'b0; // 0

                4'b1000: map_function = 1'b1; // 1
                4'b1001: map_function = 1'b1; // 1
                4'b1010: map_function = 1'b0; // 0
                4'b1011: map_function = 1'b0; // d -> 0

                4'b1100: map_function = 1'b1; // 1
                4'b1101: map_function = 1'b1; // 1
                4'b1110: map_function = 1'b0; // d -> 0
                4'b1111: map_function = 1'b0; // d -> 0

                default: map_function = 1'b0;
            endcase
        end
    endfunction

    // Assign output f using the function
    assign f = map_function(addr);

endmodule