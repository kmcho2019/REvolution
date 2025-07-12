module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;
    reg j_prev, k_prev;
    
    // Edge detection registers
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            j_prev <= 1'b0;
            k_prev <= 1'b0;
        end else begin
            j_prev <= j;
            k_prev <= k;
        end
    end
    
    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
        end else begin
            case (state)
                1'b0: if (j && !j_prev) state <= 1'b1;  // j rising edge
                1'b1: if (k && !k_prev) state <= 1'b0;  // k rising edge
            endcase
        end
    end
    
    assign out = state;
endmodule