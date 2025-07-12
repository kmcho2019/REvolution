module TopModule(
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

// Using a single implementation for both outputs to avoid redundancy
assign out_assign = a & b;
always @(*) begin
    out_alwaysblock = a & b;
end

endmodule