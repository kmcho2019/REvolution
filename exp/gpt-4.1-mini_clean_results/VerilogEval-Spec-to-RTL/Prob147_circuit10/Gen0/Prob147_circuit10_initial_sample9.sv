module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

    reg next_state;

    always @(*) begin
        if (~a & ~b)
            next_state = state;
        else if (~a & b)
            next_state = 1'b1;
        else if (a & b)
            next_state = 1'b0;
        else // a=1, b=0
            next_state = ~state;
        q = next_state;
    end

    always @(posedge clk) begin
        state <= next_state;
    end

endmodule