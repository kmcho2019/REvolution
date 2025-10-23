module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    wire [8:0] temp_result;
    assign temp_result = {a[7], a} + {b[7], b};
    assign s = temp_result[7:0];
    assign overflow = temp_result[8];

endmodule