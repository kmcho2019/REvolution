module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state = 0;  // OFF state by default
    reg j_prev, k_prev;

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            j_prev <= 0;
            k_prev <= 0;
        end else begin
            j_prev <= j;
            k_prev <= k;
            
            if (~state && j && ~j_prev)  // OFF to ON transition on j rising edge
                state <= 1;
            else if (state && k && ~k_prev)  // ON to OFF transition on k rising edge
                state <= 0;
        end
    end

    assign out = state;

endmodule