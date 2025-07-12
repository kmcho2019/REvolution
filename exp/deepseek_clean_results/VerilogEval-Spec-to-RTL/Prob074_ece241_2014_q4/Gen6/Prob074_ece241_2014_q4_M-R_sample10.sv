module TopModule (
    input clk,
    input x,
    output z
);

    // Individual flip-flops
    reg xor_ff, and_ff, or_ff;
    
    // Feedback paths with explicit naming
    wire xor_in = x ^ xor_ff;
    wire and_in = x & (~and_ff);
    wire or_in = x | (~or_ff);
    
    // Sequential logic with explicit feedback
    always @(posedge clk) begin
        xor_ff <= xor_in;
        and_ff <= and_in;
        or_ff <= or_in;
    end
    
    // Output logic - 3-input NOR of all flip-flop outputs
    assign z = ~(xor_ff | and_ff | or_ff);
    
    // Initialization via synchronous reset (more synthesis-friendly)
    initial begin
        xor_ff = 1'b0;
        and_ff = 1'b0;
        or_ff = 1'b0;
    end

endmodule