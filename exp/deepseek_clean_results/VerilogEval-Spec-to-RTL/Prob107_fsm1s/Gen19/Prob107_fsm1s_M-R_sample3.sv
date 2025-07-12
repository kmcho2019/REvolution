module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;

    // State feedback wire
    wire state;
    wire next_state;

    // Next state logic (same as original)
    assign next_state = state ? in : ~in;

    // State register implemented with feedback and mux for reset
    dff state_reg (
        .clk(clk),
        .d(reset ? STATE_B : next_state),
        .q(state)
    );

    // Output logic (same as original)
    assign out = (state == STATE_B);

endmodule

// Simple D flip-flop module for completeness
module dff (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule