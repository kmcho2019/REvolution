module TopModule(
    input logic a,
    input logic b,
    input logic c,
    output logic out
);
// Directly implement the Karnaugh map's logic with a simple OR operation
assign out = a | b | c;
endmodule