module TopModule(
    input        clock,
    input        a,
    output reg   p,
    output reg   q
);

    reg [1:0] state, next_state;
    // state[1] = p, state[0] = q

    always @(posedge clock) begin
        state <= next_state;
    end

    always @(*) begin
        // next p depends on a and current q (state[0])
        // next q depends on current p (state[1])
        next_state[1] = a & state[0];  // next p
        next_state[0] = state[1];      // next q
    end

    always @(*) begin
        p = state[1];
        q = state[0];
    end

endmodule