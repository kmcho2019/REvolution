module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

    reg next_state;

    always @(posedge clk) begin
        if (state == 0)
            next_state <= (~a & b);
        else
            next_state <= ~(a & ~b);
        state <= next_state;
    end

    assign q = next_state;

endmodule