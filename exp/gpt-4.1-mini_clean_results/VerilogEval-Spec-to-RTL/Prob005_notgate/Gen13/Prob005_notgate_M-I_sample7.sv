module TopModule (
    input  wire in,
    output wire out
);
    // Simple continuous assignment for NOT gate
    assign out = ~in;
endmodule