module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output reg        Y1
);

    // Function to compute next state bit y[1]
    function automatic logic next_y1_func(input logic [2:0] y_in, input logic w_in);
        logic y0, y1, y2;
        y0 = y_in[0];
        y1 = y_in[1];
        y2 = y_in[2];
        next_y1_func = (y0 & ~y1) | (~y0 & w_in & (y1 | y2));
    endfunction

    always @(*) begin
        Y1 = next_y1_func(y, w);
    end

endmodule