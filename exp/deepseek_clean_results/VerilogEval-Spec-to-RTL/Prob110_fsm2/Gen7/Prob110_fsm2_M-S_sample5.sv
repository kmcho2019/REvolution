module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        out <= 0;  // Reset to OFF state
    end else begin
        if (out) begin  // ON state
            out <= ~k;  // Stay ON unless k=1
        end else begin  // OFF state
            out <= j;  // Transition to ON if j=1
        end
    end
end

endmodule