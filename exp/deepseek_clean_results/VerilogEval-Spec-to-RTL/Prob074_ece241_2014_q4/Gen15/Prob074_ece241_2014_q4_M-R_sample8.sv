module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg xor_ff, and_ff, or_ff;
    
    // Combinational logic for D inputs
    wire xor_in = x ^ xor_ff;
    wire and_in = x & ~and_ff;
    wire or_in = x | ~or_ff;
    
    // Sequential logic with synchronous reset to 0
    always @(posedge clk) begin
        xor_ff <= xor_in;
        and_ff <= and_in;
        or_ff <= or_in;
    end
    
    // Output NOR gate
    assign z = ~(xor_ff | and_ff | or_ff);

    // Initialization (for simulation)
    initial begin
        xor_ff = 1'b0;
        and_ff = 1'b0;
        or_ff = 1'b0;
    end

endmodule