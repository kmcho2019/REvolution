module TopModule (
    input [3:0] in,
    output [1:0] pos
);

    wire [3:0] mask = in & ~(in - 1);  // Isolate rightmost set bit
    assign pos = (|in) ? 
                (mask[0] ? 2'b00 :
                 mask[1] ? 2'b01 :
                 mask[2] ? 2'b10 :
                 2'b11) : 2'b00;

endmodule