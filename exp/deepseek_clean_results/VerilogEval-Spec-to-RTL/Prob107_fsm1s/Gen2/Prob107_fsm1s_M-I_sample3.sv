module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;  // Current state register (1 bit): 0=B, 1=A

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to state B
        end else begin
            if (state) begin  // Current state A
                state <= in;  // in=1: stay A, in=0: go B
            end else begin    // Current state B
                state <= ~in; // in=0: go A, in=1: stay B
            end
        end
    end

    assign out = ~state;  // out=1 when state B (0), out=0 when state A (1)

endmodule