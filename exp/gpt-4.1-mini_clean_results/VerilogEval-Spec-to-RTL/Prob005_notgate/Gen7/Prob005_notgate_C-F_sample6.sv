module TopModule (
    input wire in,
    output wire out
);

    localparam MASK = 1'b1;
    assign out = in ^ MASK;

endmodule