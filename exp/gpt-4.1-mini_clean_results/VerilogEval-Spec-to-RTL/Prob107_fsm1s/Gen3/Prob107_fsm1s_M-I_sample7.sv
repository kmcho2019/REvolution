module TopModule(
    input wire clk,
    input wire reset,
    input wire in,
    output reg out
);

    // States encoded as 1-bit: 0 = B, 1 = A
    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // B state on reset
            out <= 1'b1;    // Output for B state
        end else begin
            // Transition logic
            state <= (state == 1'b0) ? ((in == 1'b0) ? 1'b1 : 1'b0)
                                     : ((in == 1'b0) ? 1'b0 : 1'b1);
            // Moore output depends only on current state (next state here)
            out <= (state == 1'b0) ? 1'b1 : 1'b0;
        end
    end

endmodule