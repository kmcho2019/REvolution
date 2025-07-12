module TopModule(
    input  [2:0] in,
    output [1:0] out
);

    always @(in) begin
        out = 2'b0;
        if (in[0]) out = out + 2'b01;
        if (in[1]) out = out + 2'b01;
        if (in[2]) out = out + 2'b01;
    end

endmodule