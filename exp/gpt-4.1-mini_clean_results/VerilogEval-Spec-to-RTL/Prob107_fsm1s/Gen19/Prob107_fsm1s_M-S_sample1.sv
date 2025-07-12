module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;

    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;          // B state
        else
            state <= (state == 1'b0) ? (in ? 1'b0 : 1'b1) : (in ? 1'b1 : 1'b0);
    end

    assign out = ~state;  // out=1 in B (state=0), out=0 in A (state=1)

endmodule