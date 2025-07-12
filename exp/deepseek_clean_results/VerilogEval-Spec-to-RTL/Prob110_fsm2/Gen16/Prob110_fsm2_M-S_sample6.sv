module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg state;  // 0 = OFF, 1 = ON

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0;
    end else if (state) begin
        state <= ~k;  // ON state: stay unless k=1
    end else begin
        state <= j;   // OFF state: go to ON if j=1
    end
end

assign out = state;

endmodule