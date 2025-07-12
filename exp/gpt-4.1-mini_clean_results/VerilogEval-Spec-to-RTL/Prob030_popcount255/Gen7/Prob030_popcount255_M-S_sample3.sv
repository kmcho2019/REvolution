module TopModule (
    input  [254:0] in,
    output reg [7:0] out
);
    integer i;
    reg [8:0] sum; // 9 bits to hold max count of 255

    always @(*) begin
        sum = 0;
        for (i = 0; i < 255; i = i + 1) begin
            sum = sum + in[i];
        end
        out = sum[7:0];
    end
endmodule