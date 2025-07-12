module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;  // B state
        else if (state == 1'b1) begin // state B
            if (in)
                state <= 1'b1; // stay in B
            else
                state <= 1'b0; // go to A
        end else begin // state A (0)
            if (in)
                state <= 1'b0; // stay in A
            else
                state <= 1'b1; // go to B
        end
    end

    always @(*) begin
        out = state;
    end

endmodule