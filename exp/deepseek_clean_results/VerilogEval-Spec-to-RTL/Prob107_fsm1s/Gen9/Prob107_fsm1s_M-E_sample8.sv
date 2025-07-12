module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // State transitions embedded in output register
    always @(posedge clk) begin
        if (reset) begin
            out <= 1'b1;  // Reset to state B (out=1)
        end else begin
            // State machine logic:
            // B->A when in=0, stay B when in=1
            // A->B when in=0, stay A when in=1
            out <= out ? (in ? 1'b1 : 1'b0) : (in ? 1'b0 : 1'b1);
        end
    end

endmodule