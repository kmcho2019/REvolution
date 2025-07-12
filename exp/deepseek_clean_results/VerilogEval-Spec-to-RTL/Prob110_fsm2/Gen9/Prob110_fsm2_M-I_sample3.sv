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
            state <= 0;
        end else begin
            // MUX-based state transition - more timing efficient than XOR
            state <= state ? (k ? 0 : 1) : (j ? 1 : 0);
        end
    end
    
    assign out = state;
endmodule