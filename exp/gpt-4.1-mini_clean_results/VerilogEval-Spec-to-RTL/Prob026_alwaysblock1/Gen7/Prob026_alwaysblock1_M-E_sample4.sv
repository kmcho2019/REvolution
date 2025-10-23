module TopModule (
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_alwaysblock
);

wire and_internal;
assign and_internal = a & b;

assign out_assign = and_internal;

always @(a or b) begin
    out_alwaysblock = and_internal;
end

endmodule