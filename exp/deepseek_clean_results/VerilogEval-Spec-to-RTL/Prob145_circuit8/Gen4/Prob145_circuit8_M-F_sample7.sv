module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;  // p captures 'a' value at clock edge
    
    if (p)    // When p was high in previous cycle
        q <= ~q;  // Toggle q
    else
        q <= q;   // Maintain q's value
end

endmodule