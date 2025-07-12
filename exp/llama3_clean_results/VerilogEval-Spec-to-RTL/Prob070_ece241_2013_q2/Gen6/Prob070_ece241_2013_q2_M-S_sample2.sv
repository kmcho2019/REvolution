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
    out_sop = (b & ~a & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);
    
    // Implementing the POS logic directly
    // Note: The POS form is essentially the inverse of the SOP form for the given conditions
    // However, since we need to explicitly define the conditions for 0, we directly implement them
    out_pos = ~( (~a & ~b & ~c & ~d) | 
                 (a & ~b & ~c & ~d) | 
                 (~a & ~b & c & ~d) | 
                 (~a & ~b & ~c & d) | 
                 (~a & b & ~c & ~d) | 
                 (~a & ~b & c & d) | 
                 (~a & b & c & ~d) | 
                 (~a & ~b & ~c & d) );
end

endmodule