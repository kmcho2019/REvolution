module TopModule(
    input  [2:0] in,
    output reg [1:0] out
);

    always @(in) begin
        out = 3'b0;
        if (in[0]) out = out + 1'b1;
        if (in[1]) out = out + 1'b1;
        if (in[2]) out = out + 1'b1;
    end

endmodule