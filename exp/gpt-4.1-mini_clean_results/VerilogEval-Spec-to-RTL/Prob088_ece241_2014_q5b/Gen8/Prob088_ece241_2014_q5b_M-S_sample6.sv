module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    reg state;  // 0 = A, 1 = B (one-hot style with single bit)

    wire next_state;

    // Next state logic
    assign next_state = state | x;

    // Sequential logic with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // reset to state A
        else
            state <= next_state;
    end

    // Output logic (Mealy)
    assign z = state ? ~x : x;

endmodule