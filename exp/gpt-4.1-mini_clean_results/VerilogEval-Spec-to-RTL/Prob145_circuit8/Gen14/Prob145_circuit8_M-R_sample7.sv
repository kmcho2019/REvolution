module TopModule(
    input       clock,
    input       a,
    output reg  p,
    output reg  q
);

    reg [1:0] state;

    always @(posedge clock) begin
        // next state logic
        state[1] <= a & state[0]; // p_next = a & q_current
        state[0] <= state[1];     // q_next = p_current

        // outputs follow state bits
        p <= state[1];
        q <= state[0];
    end

endmodule