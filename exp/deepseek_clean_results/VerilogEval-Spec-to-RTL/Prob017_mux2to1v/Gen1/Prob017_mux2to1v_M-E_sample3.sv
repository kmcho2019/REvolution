module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    wire [99:0] a_selected = a & {100{~sel}};
    wire [99:0] b_selected = b & {100{sel}};
    assign out = a_selected | b_selected;

endmodule