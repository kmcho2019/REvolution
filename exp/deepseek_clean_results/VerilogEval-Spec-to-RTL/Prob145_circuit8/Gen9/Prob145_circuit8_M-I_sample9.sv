module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_prev;  // Stores previous value of a for edge detection

always @(posedge clock) begin
    a_prev <= a;  // Register input for edge detection
    
    // p is high when current a is high and previous a was low
    p <= a & ~a_prev;
    
    // q follows p with one cycle delay
    q <= p;
end

endmodule