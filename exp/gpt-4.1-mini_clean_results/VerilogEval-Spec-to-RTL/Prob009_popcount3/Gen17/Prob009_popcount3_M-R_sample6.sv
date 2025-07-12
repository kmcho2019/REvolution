module TopModule (
    input  [2:0] in,
    output reg [1:0] out
);

    integer count;
    always @(*) begin
        count = in[0] + in[1] + in[2];
        out = count[1:0];
    end

endmodule