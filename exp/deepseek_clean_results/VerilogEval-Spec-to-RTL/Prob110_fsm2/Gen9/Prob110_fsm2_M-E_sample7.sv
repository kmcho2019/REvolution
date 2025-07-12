module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;  // 0=OFF, 1=ON
    reg j_prev, k_prev;
    
    // Edge detection registers
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            j_prev <= 0;
            k_prev <= 0;
        end else begin
            j_prev <= j;
            k_prev <= k;
        end
    end
    
    // Edge-triggered state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0;
        end else begin
            case (state)
                0: if (j && !j_prev) state <= 1;  // OFF->ON on rising j
                1: if (k && !k_prev) state <= 0;  // ON->OFF on rising k
            endcase
        end
    end
    
    assign out = state;
endmodule