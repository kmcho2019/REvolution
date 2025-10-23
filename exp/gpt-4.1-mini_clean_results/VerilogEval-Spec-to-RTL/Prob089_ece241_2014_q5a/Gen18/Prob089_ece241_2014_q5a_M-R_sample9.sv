module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    reg state;

    // State register with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;             // Initial state: copy bits
        else if (state == 1'b0 && x == 1'b1)
            state <= 1'b1;             // Switch to invert bits after first '1'
        else
            state <= state;            // Hold state
    end

    // Moore output is XOR of current input and FSM state
    assign z = x ^ state;

endmodule