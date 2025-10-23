module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Clear state definitions
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;

    reg state;

    // Combined state transition and register logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;
        end else begin
            state <= (state == STATE_B) ? (in ? STATE_B : STATE_A)
                                       : (in ? STATE_A : STATE_B);
        end
    end

    // Output is 1 when in state B, 0 when in state A
    assign out = (state == STATE_B);

endmodule