module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State register (0=B, 1=A)
    reg state;

    // Next state logic using XOR
    wire next_state = state ^ (~in);

    // State update with synchronous reset
    always @(posedge clk) begin
        state <= reset ? 1'b0 : next_state;
    end

    // Output is simply the inverted state
    assign out = ~state;

endmodule