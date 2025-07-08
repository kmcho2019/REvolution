module TopModule (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

    wire next_state;

    assign next_state = (state & ~b) | (b & ~a);

    always @(posedge clk) begin
        state <= next_state;
        q <= state & ~a & b;
    end

endmodule