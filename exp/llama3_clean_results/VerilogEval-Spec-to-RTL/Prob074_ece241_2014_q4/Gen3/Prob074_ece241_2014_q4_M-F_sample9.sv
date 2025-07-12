module TopModule(
    input  clk,
    input  x,
    output reg z
);

// Internal registers to store the state of the flip-flops
reg xor_q, and_q, or_q;

// Initialize flip-flops to zero
initial begin
    xor_q = 0;
    and_q = 0;
    or_q = 0;
end

// Always block for sequential logic (D flip-flops)
always @(posedge clk) begin
    // Calculate output of XOR gate with feedback
    reg xor_out = x ^ xor_q;
    
    // Calculate output of AND gate with complemented feedback
    reg and_out = x & ~and_q;
    
    // Calculate output of OR gate with complemented feedback
    reg or_out = x | ~or_q;
    
    // Update flip-flop states
    xor_q <= xor_out;
    and_q <= and_out;
    or_q <= or_out;
end

// Always block for combinational logic (gates and output z)
always @(*) begin
    // Calculate output of NOR gate based on the current state of the flip-flops
    reg xor_out = x ^ xor_q;
    reg and_out = x & ~and_q;
    reg or_out = x | ~or_q;
    z = ~(xor_out | and_out | or_out);
end

endmodule