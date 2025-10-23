module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg xor_ff;
    reg and_ff;
    reg or_ff;
    
    // Internal reset signal (active high)
    reg reset = 1'b1;
    
    // Combinational logic
    wire xor_out = x ^ xor_ff;
    wire and_out = x & ~and_ff;
    wire or_out  = x | ~or_ff;
    
    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            xor_ff <= 1'b0;
            and_ff <= 1'b0;
            or_ff  <= 1'b0;
            reset  <= 1'b0;  // Deassert reset after first clock
        end
        else begin
            xor_ff <= xor_out;
            and_ff <= and_out;
            or_ff  <= or_out;
        end
    end
    
    // Final NOR gate
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule