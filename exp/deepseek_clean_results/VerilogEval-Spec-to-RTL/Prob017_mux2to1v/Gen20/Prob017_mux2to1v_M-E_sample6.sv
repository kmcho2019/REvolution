module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    wire [99:0] a_selected;
    wire [99:0] b_selected;
    wire        sel_n;

    assign sel_n = ~sel;
    assign a_selected = a & {100{sel_n}};
    assign b_selected = b & {100{sel}};
    assign out = a_selected | b_selected;

endmodule