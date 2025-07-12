module TopModule (
    input wire in,
    output wire out
);
    wire internal_not;
    assign internal_not = ~in;
    assign out = internal_not;
endmodule