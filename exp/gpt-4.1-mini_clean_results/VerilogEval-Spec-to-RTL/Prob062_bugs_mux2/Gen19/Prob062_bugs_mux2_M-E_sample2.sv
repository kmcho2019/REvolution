module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output reg [7:0] out
);

    integer i;
    always @(*) begin
        for (i = 0; i < 8; i = i + 1) begin
            out[i] = sel ? b[i] : a[i];
        end
    end

endmodule