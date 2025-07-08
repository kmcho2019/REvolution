module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);
    wire next_state;
    assign next_state = (state & ~b) | (~state & a & b);

    always @(posedge clk) begin
        state <= next_state;
        q <= next_state;
    end
endmodule