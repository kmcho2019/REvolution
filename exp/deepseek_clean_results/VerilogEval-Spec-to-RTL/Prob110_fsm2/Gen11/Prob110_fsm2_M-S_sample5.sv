module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);
    always @(posedge clk or posedge areset) begin
        if (areset) out <= 0;
        else out <= out ? ~k : j;
    end
endmodule