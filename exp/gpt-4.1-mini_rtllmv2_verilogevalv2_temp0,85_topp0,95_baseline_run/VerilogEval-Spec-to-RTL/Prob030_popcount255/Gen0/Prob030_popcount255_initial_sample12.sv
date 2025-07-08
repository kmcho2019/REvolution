module TopModule (
    input  [254:0] in,
    output reg [7:0] out
);

    integer i;
    reg [8:0] count; // 9 bits to hold count up to 255

    always @(*) begin
        count = 0;
        for (i = 0; i < 255; i = i + 1) begin
            count = count + in[i];
        end
        out = count[7:0];
    end

endmodule