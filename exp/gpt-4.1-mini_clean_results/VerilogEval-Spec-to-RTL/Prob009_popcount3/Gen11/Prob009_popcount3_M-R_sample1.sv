module TopModule (
    input  [2:0] in,
    output reg [1:0] out
);

    integer i;
    reg [1:0] count;

    always @(*) begin
        count = 0;
        for (i = 0; i < 3; i = i + 1) begin
            count = count + in[i];
        end
        out = count;
    end

endmodule