module TopModule (
    input clk,
    input x,
    output reg z
);

    // Flip-flop outputs
    reg xor_ff, and_ff, or_ff;
    
    // Internal wires
    wire xor_in, and_in, or_in;
    wire xor_fb, and_fb, or_fb;

    // Feedback paths
    assign xor_fb = xor_ff;
    assign and_fb = ~and_ff;
    assign or_fb  = ~or_ff;

    // Gate implementations
    assign xor_in = x ^ xor_fb;
    assign and_in = x & and_fb;
    assign or_in  = x | or_fb;

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        xor_ff <= xor_in;
        and_ff <= and_in;
        or_ff  <= or_in;
        z <= ~(xor_ff | and_ff | or_ff);  // Three-input NOR
    end

    // Initial reset (synthesis-friendly)
    initial begin
        xor_ff = 1'b0;
        and_ff = 1'b0;
        or_ff  = 1'b0;
        z = 1'b1;  // NOR of all 0s is 1
    end

endmodule