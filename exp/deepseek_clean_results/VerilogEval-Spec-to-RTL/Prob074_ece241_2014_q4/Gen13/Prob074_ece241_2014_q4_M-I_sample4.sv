module TopModule (
    input clk,
    input x,
    output z
);

    // Combinational logic outputs
    wire xor_out, and_out, or_out;
    
    // Flip-flop outputs
    reg xor_ff, and_ff, or_ff;
    
    // Synchronous reset to initialize flip-flops
    reg [1:0] reset_cnt = 2'b0;
    wire reset = (reset_cnt < 2'b11);
    
    always @(posedge clk) begin
        if (reset) begin
            reset_cnt <= reset_cnt + 1;
            xor_ff <= 1'b0;
            and_ff <= 1'b0;
            or_ff  <= 1'b0;
        end
        else begin
            xor_ff <= xor_out;
            and_ff <= and_out;
            or_ff  <= or_out;
        end
    end
    
    // XOR path: x XOR previous xor_ff
    assign xor_out = x ^ xor_ff;
    
    // AND path: x AND NOT previous and_ff
    assign and_out = x & ~and_ff;
    
    // OR path: x OR NOT previous or_ff
    assign or_out = x | ~or_ff;
    
    // Final NOR gate
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule