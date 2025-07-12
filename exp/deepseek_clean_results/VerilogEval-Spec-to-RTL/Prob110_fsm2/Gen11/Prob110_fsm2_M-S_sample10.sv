module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);
    always @(posedge clk or posedge areset) begin
        out <= areset ? 1'b0 : (out ? ~k : j);
    end
endmodule