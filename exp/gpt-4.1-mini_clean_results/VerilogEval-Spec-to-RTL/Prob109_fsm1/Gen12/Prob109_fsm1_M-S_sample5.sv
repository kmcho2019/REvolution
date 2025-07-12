module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;              // reset to B
        else if (state == 1'b1)         // if in B
            state <= (in == 1'b0) ? 1'b0 : 1'b1;  // B--0-->A, B--1-->B
        else                            // if in A
            state <= (in == 1'b0) ? 1'b1 : 1'b0;  // A--0-->B, A--1-->A
    end

    assign out = state;                 // output equals state (B=1, A=0)

endmodule