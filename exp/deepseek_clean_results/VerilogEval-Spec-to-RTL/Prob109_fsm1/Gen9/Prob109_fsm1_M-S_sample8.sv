module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state;  // 0=A, 1=B

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;  // Reset to B
        else if (state)
            state <= in;    // B stays if in=1, goes to A if in=0
        else
            state <= ~in;   // A stays if in=1, goes to B if in=0
    end

    assign out = state;

endmodule