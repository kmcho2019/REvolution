module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state, next_state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        if (state == B)
            next_state = (in == 1'b0) ? A : B;
        else // state == A
            next_state = (in == 1'b0) ? B : A;
    end

    // Registered output: Moore output depends on current state, updated synchronously
    always @(posedge clk) begin
        if (reset)
            out <= 1'b1;  // output for state B
        else
            out <= (state == B) ? 1'b1 : 1'b0;
    end

endmodule