module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state = 0;
    reg j_prev, k_prev;

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            j_prev <= 0;
            k_prev <= 0;
        end else begin
            j_prev <= j;
            k_prev <= k;
            
            if (~j_prev && j)  // Rising edge of j
                state <= 1;
            else if (~k_prev && k)  // Rising edge of k
                state <= 0;
        end
    end

    assign out = state;

endmodule