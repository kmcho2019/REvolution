module TopModule(
    input  a,
    input  b,
    input  select,
    output out_assign,
    output out_alwaysblock,
    output out_mux
);

// Implement AND gate using assign statement
assign out_assign = a & b;

// Implement AND gate using combinational always block
reg out_always;
always @(*) begin
    out_always = a & b;
end
assign out_alwaysblock = out_always;

// Use a MUX to select between out_assign and out_alwaysblock
assign out_mux = (select == 0) ? out_assign : out_alwaysblock;

endmodule