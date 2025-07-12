module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff,
    output wire error_flag
);

    // Basic XOR implementations
    assign out_assign = a ^ b;
    
    always @(*) begin
        out_always_comb = a ^ b;
    end
    
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

    // Consistency checking logic
    wire comb_match = (out_assign == out_always_comb);
    wire seq_match  = (out_always_ff == out_assign);
    reg error_latched;
    
    assign error_flag = ~(comb_match & seq_match) | error_latched;
    
    // Optional error latching (for debugging)
    always @(posedge clk) begin
        if (~comb_match || ~seq_match)
            error_latched <= 1'b1;
        // Note: Would need reset in real implementation
    end

endmodule