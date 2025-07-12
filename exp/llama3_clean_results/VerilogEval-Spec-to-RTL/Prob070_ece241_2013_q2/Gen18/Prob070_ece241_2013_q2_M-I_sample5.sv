module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic out_sop,
    output logic out_pos
);

// Corrected implementation for SOP
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Corrected implementation for POS
// The numbers 0, 1, 4, 5, 6, 9, 10, 13, and 14 should produce a logic-0
// Applying De Morgan's laws and simplifying the resulting expression
assign out_pos = ~( (a & ~b & ~c & ~d) | 
                   (a & ~b & ~c & d) | 
                   (~a & b & ~c & ~d) | 
                   (~a & ~b & c & ~d) | 
                   (~a & ~b & c & d) | 
                   (~a & ~b & ~c & ~d) | 
                   (~a & b & ~c & d) | 
                   (~a & ~b & ~c & d) | 
                   (a & ~b & c & ~d) );

endmodule