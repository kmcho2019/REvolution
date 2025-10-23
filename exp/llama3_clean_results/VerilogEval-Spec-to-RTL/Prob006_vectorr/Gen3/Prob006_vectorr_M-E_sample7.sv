module TopModule(
    input  [7:0] in,
    output [7:0] out
);

    assign out = ({8{1'b0}}, in)[7:0];

endmodule