module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output reg [24:0] out
);

    reg [4:0] pattern = {a, b, c, d, e};
    reg [4:0] mask;
    integer i, j;

    always @(*) begin
        for (i = 0; i < 5; i = i + 1) begin
            mask = pattern;
            for (j = 0; j < 5; j = j + 1) begin
                out[24 - (i*5 + j)] = mask[4] ~^ mask[4-j];
            end
            // Rotate pattern left by 1
            pattern = {pattern[3:0], pattern[4]};
        end
    end

endmodule