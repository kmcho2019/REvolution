module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;  // 0 = B, 1 = A

    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;        // B
        else
            state <= (state ^ in); // Toggle state on input=0 in B, hold on others
    end

    assign out = ~state; // out=1 in B (state=0), out=0 in A (state=1)

endmodule