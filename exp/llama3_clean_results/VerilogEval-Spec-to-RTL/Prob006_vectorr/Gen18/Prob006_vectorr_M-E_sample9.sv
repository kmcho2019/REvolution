module TopModule(
    input  [7:0] in,
    output [7:0] out
);

integer i;

always @(*) begin
    out = 8'b0;
    for (i = 0; i < 8; i++) begin
        out[7-i] = in[i];
    end
end

endmodule