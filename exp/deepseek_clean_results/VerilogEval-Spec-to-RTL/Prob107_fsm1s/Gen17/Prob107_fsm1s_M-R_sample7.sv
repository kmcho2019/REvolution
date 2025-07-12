module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State definitions
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;

    wire next_state;
    reg current_state;

    // State transition logic (combinational)
    assign next_state = reset ? STATE_B :  // Reset has highest priority
                      (current_state == STATE_B) ? ~in : in;

    // State register (sequential)
    always @(posedge clk) begin
        current_state <= next_state;
    end

    // Output logic (combinational)
    assign out = (current_state == STATE_B);

endmodule