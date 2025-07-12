module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;
    reg j_prev, k_prev;
    
    // Edge detection
    wire j_edge = j & ~j_prev;
    wire k_edge = k & ~k_prev;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            j_prev <= 1'b0;
            k_prev <= 1'b0;
        end else begin
            j_prev <= j;
            k_prev <= k;
            
            case (state)
                1'b0: if (j_edge) state <= 1'b1;
                1'b1: if (k_edge) state <= 1'b0;
            endcase
        end
    end
    
    assign out = state;
endmodule