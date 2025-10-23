module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;  // 0 = B, 1 = A

    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;  // B state
        else if (state == 1'b0)  // B
            state <= (in == 1'b0) ? 1'b1 : 1'b0;
        else  // A
            state <= (in == 1'b0) ? 1'b0 : 1'b1;
    end

    assign out = (state == 1'b0);

endmodule