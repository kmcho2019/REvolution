module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    reg state;      // 0 = OFF, 1 = ON
    reg next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;  // OFF
        else
            state <= next_state;
    end

    // Next state logic using simple combinational expressions
    always @(*) begin
        // From OFF state (0): next = ON if j=1 else OFF
        // From ON state (1): next = OFF if k=1 else ON
        if (state == 1'b0)
            next_state = j ? 1'b1 : 1'b0;
        else
            next_state = k ? 1'b0 : 1'b1;
    end

    // Registered output reflecting current state (Moore machine)
    always @(posedge clk) begin
        if (reset)
            out <= 1'b0;
        else
            out <= state;
    end

endmodule