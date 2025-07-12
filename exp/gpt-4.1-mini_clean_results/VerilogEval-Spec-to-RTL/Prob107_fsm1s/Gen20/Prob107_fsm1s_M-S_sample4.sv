module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    reg state; // 0 = B, 1 = A

    always @(posedge clk) begin
        if (reset)
            state <= 1'b0; // reset to B
        else
            state <= (state == 1'b0) ? (in ? 1'b0 : 1'b1) : (in ? 1'b1 : 1'b0);
    end

    assign out = ~state;

endmodule