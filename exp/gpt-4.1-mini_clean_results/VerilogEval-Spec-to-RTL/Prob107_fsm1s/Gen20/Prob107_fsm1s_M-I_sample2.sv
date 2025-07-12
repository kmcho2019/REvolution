module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    reg state;          // 0: B, 1: A
    reg next_state;

    always @* begin
        if (state == 1'b0)      // B state
            next_state = in ? 1'b0 : 1'b1;
        else                    // A state
            next_state = in ? 1'b1 : 1'b0;
    end

    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;     // B state on reset
        else
            state <= next_state;
    end

    assign out = ~state;       // out=1 for B(state=0), 0 for A(state=1)

endmodule