module TopModule(
    input  in,
    output reg out
);

// Using an always block for potential future expansion
always @(*)
begin
    out = ~in;
end

endmodule