module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    reg state; // 1: B, 0: A

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1; // reset to state B
        else if (state == 1'b1) begin
            // state B: if in=0 go to A(0), else stay B(1)
            if (in == 1'b0)
                state <= 1'b0;
            else
                state <= 1'b1;
        end else begin
            // state A: if in=0 go to B(1), else stay A(0)
            if (in == 1'b0)
                state <= 1'b1;
            else
                state <= 1'b0;
        end
    end

    always @(*) begin
        out = state;
    end

endmodule