module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] in_bits = {a, b, c, d, e};
    integer i, j;
    reg [24:0] result;

    always @(*) begin
        integer idx;
        idx = 24;
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                result[idx] = (in_bits[i] == in_bits[j]) ? 1'b1 : 1'b0;
                idx = idx - 1;
            end
        end
    end

    assign out = result;

endmodule