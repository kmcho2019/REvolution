module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state; // 0 = B, 1 = A

    always @(posedge clk) begin
        if (reset)
            state <= 1'b0; // B state
        else
            state <= (state == 1'b0) ? ~in : in;
    end

    assign out = ~state; // out=1 in B(0), out=0 in A(1)

endmodule