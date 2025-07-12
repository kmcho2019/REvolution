module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Implement 100-bit mux using bitwise AND/OR to potentially improve PPA
    assign out = (a & {100{~sel}}) | (b & {100{sel}});
endmodule