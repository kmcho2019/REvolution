module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out <= 1'b0;  // Reset to OFF (out=0)
        end else begin
            out <= out ? ~k : j;
        end
    end
endmodule