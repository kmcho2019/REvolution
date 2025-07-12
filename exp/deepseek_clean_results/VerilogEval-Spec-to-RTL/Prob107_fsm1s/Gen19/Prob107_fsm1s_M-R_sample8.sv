module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    always @(posedge clk) begin
        if (reset) begin
            out <= 1'b1;  // Reset to state B (out=1)
        end else begin
            // State transition logic:
            // If current state is B (out=1), next state is ~in
            // If current state is A (out=0), next state is in
            out <= out ? (in) : (in);
        end
    end

endmodule