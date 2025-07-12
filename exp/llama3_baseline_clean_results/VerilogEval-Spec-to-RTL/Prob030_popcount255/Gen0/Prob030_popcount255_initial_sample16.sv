module TopModule(
    input  [254:0] in,
    output [7:0] out
);

reg [7:0] count;

always @(*) begin
    count = $countones(in);
    out = count;
end

endmodule