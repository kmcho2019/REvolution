module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

    // Combinational logic for q based on state, a, b
    assign q = (state & b) | (~state & ~a);

    // Sequential logic to update state at positive edge of clk
    always @(posedge clk) begin
        state <= q;
    end

endmodule