module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

    reg next_state;

    // Combinational logic for next_state and output q
    always @(*) begin
        // Next state logic
        if (b)
            next_state = ~a;
        else
            next_state = state;

        // Output logic
        q = (state & ~b) | (~state & ~a & b);
    end

    // Sequential logic for state update
    always @(posedge clk) begin
        state <= next_state;
    end

endmodule