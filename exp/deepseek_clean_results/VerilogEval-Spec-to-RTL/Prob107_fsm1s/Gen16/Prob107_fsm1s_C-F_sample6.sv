module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Parameterized states for better readability
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;

    reg state;

    // State transitions with clear if-else structure
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;  // Synchronous reset to state B
        end else begin
            if (state == STATE_B) begin
                state <= in ? STATE_B : STATE_A;  // B->B if in=1, B->A if in=0
            end else begin
                state <= in ? STATE_A : STATE_B;  // A->A if in=1, A->B if in=0
            end
        end
    end

    // Explicit output assignment for clarity
    assign out = (state == STATE_B);  // out=1 when in state B

endmodule