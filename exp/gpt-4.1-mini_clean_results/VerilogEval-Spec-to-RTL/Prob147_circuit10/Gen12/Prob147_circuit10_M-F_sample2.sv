module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

    wire next_state;

    // Next state logic:
    // If currently 0, next state is set to 1 only when a=0 and b=1.
    // If currently 1, next state is 1 only when a=0 and b=0, else reset to 0.
    assign next_state = (state == 1'b0) ? (~a & b) : (~a & ~b);

    assign q = state;

    // Initialize state to 0 at start (synchronous reset style)
    // No asynchronous reset given in interface, so initialize in an initial block
    // to avoid simulation x states.
    initial begin
        state = 1'b0;
    end

    always @(posedge clk) begin
        state <= next_state;
    end

endmodule