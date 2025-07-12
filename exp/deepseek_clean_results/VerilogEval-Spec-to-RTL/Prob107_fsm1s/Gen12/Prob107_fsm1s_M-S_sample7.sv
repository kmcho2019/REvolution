module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;  // 0=B, 1=A
    
    always @(posedge clk) begin
        if (reset) begin
            state <= 0;  // Reset to state B
        end else begin
            state <= (state == 0) ? (in ? 0 : 1) : (in ? 1 : 0);
        end
    end
    
    assign out = ~state;  // B=0 (out=1), A=1 (out=0)
    
endmodule