module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    reg state; // 0: B, 1: A

    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;          // B state on reset
        else if (state == 1'b0)    // B state
            state <= in ? 1'b0 : 1'b1;
        else                       // A state
            state <= in ? 1'b1 : 1'b0;
    end

    assign out = ~state; // out=1 for B(state=0), 0 for A(state=1)

endmodule