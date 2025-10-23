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
            if (~state & j) state <= 1'b1;  // OFF->ON when j=1
            else if (state & k) state <= 1'b0;  // ON->OFF when k=1
        end
    end
    
    assign out = state;
endmodule