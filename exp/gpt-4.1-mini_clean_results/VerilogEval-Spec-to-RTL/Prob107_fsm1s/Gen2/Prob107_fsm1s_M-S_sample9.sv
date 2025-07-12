module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

    reg state; // 0 = B, 1 = A

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 1'b0; // B state
        else
            state <= (state == 1'b0) ? (~in) : in;
    end

    // Output depends only on state: B -> 1, A -> 0
    assign out = ~state;

endmodule