module TopModule(
    input  [7:0] in,
    output [7:0] out
);

    reg [7:0] temp;

    always @(*) begin
        temp = in;
        out[0] = temp[7];
        out[1] = temp[6];
        out[2] = temp[5];
        out[3] = temp[4];
        out[4] = temp[3];
        out[5] = temp[2];
        out[6] = temp[1];
        out[7] = temp[0];
    end

endmodule