module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    always @(posedge clk) begin
        if (reset)
            out <= 1'b0;             // OFF state with output 0
        else if (out == 1'b0)
            out <= j ? 1'b1 : 1'b0; // OFF state transitions based on j
        else
            out <= k ? 1'b0 : 1'b1; // ON state transitions based on k
    end

endmodule