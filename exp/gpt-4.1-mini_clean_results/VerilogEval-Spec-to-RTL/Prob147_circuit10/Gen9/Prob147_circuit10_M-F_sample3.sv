module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

    wire next_state;

    assign next_state = (state & ~a) | b;
    assign q = next_state;

    always @(posedge clk) begin
        state <= next_state;
    end

endmodule