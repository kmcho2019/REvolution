module TopModule(
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

// Direct implementation for efficiency and simplicity
assign out_assign = a & b;

// Modular and readable implementation for the always block
always @(*) begin
    out_alwaysblock = a & b;
end

endmodule