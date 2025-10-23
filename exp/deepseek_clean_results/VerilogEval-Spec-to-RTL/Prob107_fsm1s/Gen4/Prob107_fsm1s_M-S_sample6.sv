module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;  // 0=B, 1=A

    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;  // Reset to state B
        else
            state <= state ? in : ~in;  // A: stay if in=1, B: stay if in=0
    end

    assign out = ~state;  // out=1 when in state B (0)

endmodule