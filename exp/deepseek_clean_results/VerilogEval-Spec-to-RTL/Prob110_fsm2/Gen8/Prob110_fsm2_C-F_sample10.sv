module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;  // 0=OFF, 1=ON
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
        end else begin
            state <= (state ? ~k : j) ^ state;  // Toggle when j/k=1 in respective states
        end
    end
    
    assign out = state;
endmodule