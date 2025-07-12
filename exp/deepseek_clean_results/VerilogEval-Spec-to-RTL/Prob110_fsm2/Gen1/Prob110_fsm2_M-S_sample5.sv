module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out <= 1'b0;  // OFF state
        end else begin
            case (out)
                1'b0: out <= j ? 1'b1 : 1'b0;  // OFF to ON if j=1
                1'b1: out <= k ? 1'b0 : 1'b1;  // ON to OFF if k=1
            endcase
        end
    end

endmodule