module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

always @(*) begin
    // Implementing the SOP logic directly
    out_sop = (~a & b & (~c & ~d | c & d)) | (a & b & c & d);
    
    // Implementing the POS logic directly
    out_pos = ~((~a & ~b & ~c & ~d) | 
                 (~a & ~b & ~c & d) | 
                 (~a & b & ~c & ~d) | 
                 (~a & b & ~c & d) | 
                 (~a & b & c & ~d) | 
                 (a & ~b & ~c & d) | 
                 (a & ~b & c & ~d) | 
                 (a & b & ~c & d) | 
                 (a & b & c & ~d));
end

endmodule