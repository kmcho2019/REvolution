module TopModule (
    input  [99:0] in,
    output [99:0] out
);

reg [99:0] reversed;

always @(*) begin
    for (integer i = 0; i < 100; i = i + 1) begin
        reversed[i] = in[99 - i];
    end
end

assign out = reversed;

endmodule