module TopModule (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

    reg next_state;

    // Combinational logic to determine next state and output q
    always @(*) begin
        // Next state logic
        // next_state = (state AND NOT b AND NOT a) OR (NOT state AND b)
        next_state = (state & ~b & ~a) | (~state & b);

        // Output q logic
        // q = (state AND (a OR b)) OR ((~state) AND b AND ~a)
        q = (state & (a | b)) | (~state & b & ~a);
    end

    // Sequential logic for state update at posedge clk
    always @(posedge clk) begin
        state <= next_state;
    end

endmodule