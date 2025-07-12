module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    always @(posedge clk) begin
        if (reset) begin
            out <= 1'b0;
        end else begin
            if (out) begin    // ON state
                out <= ~k;
            end else begin     // OFF state
                out <= j;
            end
        end
    end

endmodule