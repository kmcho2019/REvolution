module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Identify and group adjacent cells in the Karnaugh map to simplify the logic
assign out = ((a & b) | (~a & b) | (a & ~b)) & ((~c & ~d) | (~c & d) | (c & d));

// Alternatively, further simplify by recognizing common factors
assign out = (b | a) & ((~c & (~d | d)) | (c & d));

// Final simplification considering the properties of Boolean algebra
assign out = (a | b) & (~c | d);

endmodule