module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

    wire next_state;

    // Next state logic: update only when b=1, else hold state
    assign next_state = b ? (~a) : state;

    // Output logic combinational from current state and inputs
    always @(*) begin
        q = (state & ~b) | (~state & ~a & b);
    end

    // State update on rising edge of clk
    always @(posedge clk) begin
        state <= next_state;
    end

endmodule