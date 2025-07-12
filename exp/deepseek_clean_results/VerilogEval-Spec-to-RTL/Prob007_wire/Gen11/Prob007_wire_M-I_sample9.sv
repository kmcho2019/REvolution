// Simple wire connection module
// Directly connects input 'in' to output 'out'
module TopModule (
    input  in,
    output out
);
    assign out = in;
endmodule