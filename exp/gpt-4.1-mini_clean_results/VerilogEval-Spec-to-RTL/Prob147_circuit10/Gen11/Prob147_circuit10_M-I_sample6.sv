module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

    wire next_state;

    assign next_state = ((~state) & (~a) & b) | (state & ~(a ^ b));
    assign q = state;

    always @(posedge clk) begin
        state <= next_state;
    end

endmodule