module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

wire a_buf;
wire b_delayed;

// Assign a_buf directly from input 'a'
assign a_buf = a;

// Buffer b with a zero-delay buffer (conceptual, synthesized as a simple wire)
assign b_delayed = b;

assign out_assign = a & b;

always @(*) begin
    out_alwaysblock = a_buf & b_delayed;
end

endmodule