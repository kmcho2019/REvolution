module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg j_prev, k_prev;
    reg state = 0;  // OFF state initially

    always @(posedge clk) begin
        j_prev <= j;
        k_prev <= k;
        
        if (reset) begin
            state <= 0;
        end
        else begin
            // Transition to ON at rising edge of j when in OFF state
            if (~state && j && ~j_prev)
                state <= 1;
            // Transition to OFF at rising edge of k when in ON state
            else if (state && k && ~k_prev)
                state <= 0;
        end
    end

    assign out = state;

endmodule