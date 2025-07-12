module TopModule(
    input [2:0] in,
    output [1:0] out
);

    reg [1:0] count;

    always @(*) begin
        count = 0;
        if (in[0]) count = count + 1;
        if (in[1]) count = count + 1;
        if (in[2]) count = count + 1;
        out = count;
    end

endmodule