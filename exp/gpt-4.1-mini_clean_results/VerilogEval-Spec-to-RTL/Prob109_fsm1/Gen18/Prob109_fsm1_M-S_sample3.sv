module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;       // state B
        else
            state <= (state == 1'b1) ? (in ? 1'b1 : 1'b0) : (in ? 1'b0 : 1'b1);
    end

    assign out = state;

endmodule