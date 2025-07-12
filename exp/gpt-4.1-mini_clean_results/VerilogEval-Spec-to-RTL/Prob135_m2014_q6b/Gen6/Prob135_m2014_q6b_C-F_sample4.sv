module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Function implementing the minimized next-state logic for y[1]
    function logic get_next_y1(input logic y2, input logic y1, input logic y0, input logic w);
        begin
            // next_y1 = (~y2) & ((~y1 & y0) | (y1 & ~y0 & w)) 
            //         | (y2 & (~y1) & ((~y0 & w) | y0));
            get_next_y1 = (~y2) & ((~y1 & y0) | (y1 & ~y0 & w))
                        |  (y2 & (~y1) & ((~y0 & w) | y0));
        end
    endfunction

    assign Y1 = get_next_y1(y2, y1, y0, w);

endmodule