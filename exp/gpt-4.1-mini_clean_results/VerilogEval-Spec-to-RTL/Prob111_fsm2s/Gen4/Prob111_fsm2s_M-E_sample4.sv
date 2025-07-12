module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    reg state;

    // State encoding: 0=OFF, 1=ON
    // On synchronous reset, state and output go to OFF/0.
    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;
            out <= 1'b0;
        end else begin
            // Compute next state
            state <= (state == 1'b0) ? (j ? 1'b1 : 1'b0) : (k ? 1'b0 : 1'b1);
            // Output equals state
            out <= (state == 1'b0) ? 1'b0 : 1'b1;
        end
    end

endmodule