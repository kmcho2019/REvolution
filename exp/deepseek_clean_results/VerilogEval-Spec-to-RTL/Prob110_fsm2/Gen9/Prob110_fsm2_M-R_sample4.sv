module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    // State storage wire
    wire state;
    wire next_state;

    // Toggle condition remains the same
    wire toggle_condition = (state ? k : j);

    // Next state logic
    assign next_state = areset ? 1'b0 : (state ^ toggle_condition);

    // D flip-flop implementation using continuous assignment
    dff state_ff (
        .clk(clk),
        .d(next_state),
        .q(state)
    );

    // Output is just the state (Moore machine)
    assign out = state;

endmodule

// Simple D flip-flop model
module dff (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule