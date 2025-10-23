module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    // State stored in 'out' directly: 0 = OFF, 1 = ON

    always @(posedge clk) begin
        if (reset)
            out <= 1'b0;            // OFF state
        else if (out == 1'b0)
            out <= j ? 1'b1 : 1'b0;
        else
            out <= k ? 1'b0 : 1'b1;
    end

endmodule