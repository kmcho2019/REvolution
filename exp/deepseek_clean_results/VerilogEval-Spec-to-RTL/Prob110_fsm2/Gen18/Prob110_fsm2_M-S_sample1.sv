module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        out <= 1'b0;
    end else if (out) begin
        out <= ~k;  // ON state: stay unless k=1
    end else begin
        out <= j;   // OFF state: go to ON if j=1
    end
end

endmodule