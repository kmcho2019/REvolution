module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

    wire next_state;
    wire next_q;

    // Next state logic:
    // state <= (state & ~(a & b)) | (~state & ~a & b)
    assign next_state = (state & ~(a & b)) | (~state & (~a & b));

    // Output logic:
    // q = (~state & b) | (state & a & ~b)
    assign next_q = (~state & b) | (state & a & ~b);

    always @(posedge clk) begin
        state <= next_state;
        q <= next_q;
    end

endmodule