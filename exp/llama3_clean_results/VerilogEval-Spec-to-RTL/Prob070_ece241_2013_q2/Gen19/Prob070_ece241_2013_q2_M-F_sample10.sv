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
// Using the conditions for inputs 2, 7, and 15 to derive the POS expression
// The POS expression should be the complement of the sum of the conditions that produce a logic-0
assign out_pos = ~( (~a & ~b & ~c & ~d) | 
                   (a & ~b & ~c & ~d) | 
                   (a & ~b & ~c & d) | 
                   (~a & ~b & c & ~d) | 
                   (~a & ~b & c & d) | 
                   (~a & ~b & ~c & d) | 
                   (~a & b & ~c & d) | 
                   (a & ~b & c & ~d) | 
                   (~a & b & ~c & ~d) );

endmodule