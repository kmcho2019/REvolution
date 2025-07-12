module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg j_prev, k_prev;
    reg output_state;
    
    always @(posedge clk) begin
        if (reset) begin
            output_state <= 0;
            j_prev <= 0;
            k_prev <= 0;
        end
        else begin
            j_prev <= j;
            k_prev <= k;
            
            // Detect rising edge of j when in OFF state
            if (~output_state && j && ~j_prev)
                output_state <= 1;
            
            // Detect rising edge of k when in ON state
            if (output_state && k && ~k_prev)
                output_state <= 0;
        end
    end
    
    assign out = output_state;

endmodule