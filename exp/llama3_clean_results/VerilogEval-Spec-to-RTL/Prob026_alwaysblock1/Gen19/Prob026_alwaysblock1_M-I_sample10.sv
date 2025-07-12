// TopModule that combines assign statement and combinational always block
module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);
    
assign out_assign = a & b;

always @(*) begin
    out_alwaysblock = a & b;
end

endmodule