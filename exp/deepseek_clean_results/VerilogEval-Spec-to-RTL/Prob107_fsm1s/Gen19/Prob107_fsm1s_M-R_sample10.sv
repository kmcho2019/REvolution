module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State definitions
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;

    // State register and next state wire
    reg state;
    wire next_state;

    // Next state logic using continuous assignment
    assign next_state = reset ? STATE_B : 
                      (state == STATE_B) ? (in ? STATE_B : STATE_A) :
                                           (in ? STATE_A : STATE_B);

    // State register (explicit DFF)
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output assignment remains the same
    assign out = (state == STATE_B);

endmodule