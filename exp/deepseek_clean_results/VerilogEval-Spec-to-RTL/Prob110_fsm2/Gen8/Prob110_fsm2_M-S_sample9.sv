module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;  // 0=OFF, 1=ON
    
    always @(posedge clk or posedge areset) begin
        state <= areset ? 1'b0 : (state ? ~k : j);
    end
    
    assign out = state;
endmodule