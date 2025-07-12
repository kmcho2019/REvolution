module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out <= 0;
        end else if (out) begin
            out <= ~k;
        end else begin
            out <= j;
        end
    end
endmodule