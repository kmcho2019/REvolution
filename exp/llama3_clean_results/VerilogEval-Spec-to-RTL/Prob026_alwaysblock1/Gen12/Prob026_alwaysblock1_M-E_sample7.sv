module TopModule(
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

wire internal_signal;

assign internal_signal = a & b;
assign out_assign = internal_signal;

always @(*) begin
    out_alwaysblock = internal_signal;
end

endmodule