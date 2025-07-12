module TopModule (
    input clk,
    input L,
    input q_in,    // Feedback input (neighbor's state)
    input r_in,    // Load input
    output reg Q   // Current state output
);

    // Position parameter (0, 1, or 2)
    parameter POSITION = 0;

    // Internal signals
    wire next_state;

    // Next state logic
    assign next_state = L ? r_in : 
                      (POSITION == 1) ? (Q ^ q_in) : 
                      q_in;

    always @(posedge clk) begin
        Q <= next_state;
    end

endmodule