module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg state;  // 0 = OFF, 1 = ON
reg j_prev, k_prev;  // For edge detection

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0;       // Async reset to OFF
        j_prev <= 1'b0;
        k_prev <= 1'b0;
    end else begin
        j_prev <= j;        // Store previous input values
        k_prev <= k;
        
        // Toggle state on rising edge of j (OFF->ON) or k (ON->OFF)
        if ((~state & ~j_prev & j) | (state & ~k_prev & k)) begin
            state <= ~state;
        end
    end
end

assign out = state;

endmodule