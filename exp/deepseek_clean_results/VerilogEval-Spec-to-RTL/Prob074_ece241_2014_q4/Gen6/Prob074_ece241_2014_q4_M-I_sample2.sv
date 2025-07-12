module TopModule (
    input clk,
    input x,
    output z
);

    // Individual flip-flop declarations
    reg xor_ff;
    reg and_ff;
    reg or_ff;
    
    // Feedback paths
    wire xor_fb = xor_ff;
    wire and_fb = ~and_ff;
    wire or_fb = ~or_ff;
    
    // Next state logic
    wire xor_next = x ^ xor_fb;
    wire and_next = x & and_fb;
    wire or_next = x | or_fb;
    
    // Sequential logic with explicit reset-to-zero
    always @(posedge clk) begin
        xor_ff <= xor_next;
        and_ff <= and_next;
        or_ff <= or_next;
    end
    
    // Output logic - 3-input NOR of all flip-flop outputs
    assign z = ~(xor_ff | and_ff | or_ff);
    
    // Initialization - alternative synthesis-friendly method
    initial begin
        xor_ff = 1'b0;
        and_ff = 1'b0;
        or_ff = 1'b0;
    end

endmodule