module TopModule(
    input  [99:0] in,
    output [99:0] out
);

reg [99:0] shift_reg;
integer i;

always @(posedge in) begin
    shift_reg = in;
    for (i = 0; i < 100; i++) begin
        out[i] = shift_reg[99 - i];
    end
end

endmodule