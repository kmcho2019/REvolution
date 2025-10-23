module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

reg next_state;

always @(*) begin
    if (b == 1'b0) begin
        // If b=0 and a=1 and state=1, reset state to 0, else hold
        if (a == 1'b1 && state == 1'b1)
            next_state = 1'b0;
        else
            next_state = state;
    end else begin
        // b=1
        if (a == 1'b1)
            next_state = 1'b0;
        else
            next_state = ~state;
    end
end

always @(posedge clk) begin
    state <= next_state;
end

assign q = (b == 1'b1) ? (state ^ a) : state;

initial begin
    state = 1'b0;
end

endmodule