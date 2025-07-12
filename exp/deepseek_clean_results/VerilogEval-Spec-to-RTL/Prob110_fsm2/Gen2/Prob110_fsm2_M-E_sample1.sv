module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

    wire toggle_condition = (out == 0) ? j : k;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out <= 1'b0;
        end else if (toggle_condition) begin
            out <= ~out;
        end
    end

endmodule