module TopModule(
    input clk,
    input x,
    output reg z
);

reg q0, q1, q2; // Individual D flip-flops

// Sequential logic to update the flip-flops
always @(posedge clk) begin
    q0 <= x ^ q0;
    q1 <= x & ~q1;
    q2 <= x | ~q2;
end

// Combinational logic to compute the output 'z'
assign z = ~(x ^ q0 | x & ~q1 | x | ~q2);
assign z = ~(x ^ q0 | (x & ~q1) | (x | ~q2)); 
//this is the NOR gate output directly applied without an intermediate temp
assign z = ~((x ^ q0) | (x & ~q1) | (x | ~q2));
//as mentioned earlier we use ~ for NOR 
// NOR has a high priority than OR 
// NOR has a lower priority than XOR and AND 

endmodule