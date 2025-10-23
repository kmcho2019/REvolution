module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;
    reg j_prev, k_prev;

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            j_prev <= 0;
            k_prev <= 0;
        end else begin
            j_prev <= j;
            k_prev <= k;
            
            case (state)
                0: if (j && !j_prev) state <= 1;  // OFF to ON on j rising edge
                1: if (k && !k_prev) state <= 0;  // ON to OFF on k rising edge
            endcase
        end
    end

    assign out = state;

endmodule