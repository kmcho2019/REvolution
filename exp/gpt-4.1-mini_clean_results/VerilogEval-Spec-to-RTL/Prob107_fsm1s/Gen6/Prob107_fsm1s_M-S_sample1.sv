module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

    reg state;

    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;        // B state
        else if (state == 1'b0) // B
            state <= (in == 1'b0) ? 1'b1 : 1'b0; // B->A if in=0 else B
        else                   // A
            state <= (in == 1'b0) ? 1'b0 : 1'b1; // A->B if in=0 else A
    end

    assign out = ~state; // out=1 in B(0), 0 in A(1)

endmodule