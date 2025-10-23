module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [4:0] x_ext = {1'b0, x};
    wire [4:0] y_ext = {1'b0, y};

    assign sum = x_ext + y_ext;
endmodule