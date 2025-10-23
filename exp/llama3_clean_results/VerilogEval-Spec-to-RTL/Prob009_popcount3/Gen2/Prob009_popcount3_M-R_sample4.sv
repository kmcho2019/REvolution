module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    logic [1:0] count;

    always @(*) begin
        count = in[0] + in[1] + in[2];
        out = count;
    end

endmodule