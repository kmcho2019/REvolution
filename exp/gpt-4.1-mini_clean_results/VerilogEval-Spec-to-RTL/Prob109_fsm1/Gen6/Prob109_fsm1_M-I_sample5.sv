module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding: A = 0, B = 1
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    wire next_state;
    wire state_change;

    // Simplified next_state logic using direct boolean expressions:
    // From diagram:
    // If state==B(1):
    //    in=0 => next_state=A(0)
    //    in=1 => next_state=B(1)
    // If state==A(0):
    //    in=0 => next_state=B(1)
    //    in=1 => next_state=A(0)
    //
    // Observing:
    // next_state = (state & in) | (~state & ~in)
    // i.e., next_state = (state == in)
    assign next_state = (state & in) | (~state & ~in);

    // Only update state when it changes, reducing toggling and power
    assign state_change = (state != next_state);

    // Asynchronous reset with clock enable gating
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else if (state_change) begin
            state <= next_state;
        end
    end

    // Output equals 1 when in state B, else 0
    assign out = state;

endmodule