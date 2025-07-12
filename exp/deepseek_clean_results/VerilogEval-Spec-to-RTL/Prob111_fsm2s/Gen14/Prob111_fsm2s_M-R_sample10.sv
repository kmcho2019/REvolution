module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    // State signals
    wire current_state;
    wire next_state;

    // State transition logic (combinational)
    assign next_state = reset ? OFF : 
                       (current_state == OFF) ? (j ? ON : OFF) :
                       (k ? OFF : ON);

    // State register (sequential)
    dff state_ff (
        .clk(clk),
        .d(next_state),
        .q(current_state)
    );

    // Output logic
    assign out = current_state;

endmodule

// Basic D-flip-flop with synchronous reset
module dff (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule