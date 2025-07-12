module TopModule (
    input  in1,
    input  in2,
    output reg out
);

always @* begin
    // Compute NOR using procedural assignment
    out = ~(in1 | in2);
end

endmodule