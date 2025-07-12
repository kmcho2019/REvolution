module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    reg [255:0] temp;
    assign temp = (in >> sel);
    assign out = temp[255];

endmodule