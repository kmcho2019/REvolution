module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output reg        Y1
);

    // Function to compute next state bit y[1] with factored logic
    function automatic logic next_y1_func(input logic [2:0] y_in, input logic w_in);
        logic y0, y1, y2, y1_or_y2, not_y0, not_y1;
        y0 = y_in[0];
        y1 = y_in[1];
        y2 = y_in[2];
        y1_or_y2 = y1 | y2;
        not_y0 = ~y0;
        not_y1 = ~y1;
        next_y1_func = (y0 & not_y1) | (not_y0 & w_in & y1_or_y2);
    endfunction

    always @(*) begin
        Y1 = next_y1_func(y, w);
    end

endmodule