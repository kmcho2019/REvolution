module TopModule (
    input  clk,
    input  aresetn, // active low asynchronous reset (negative edge)
    input  x,
    output reg z
);

    // One-hot encoded states
    localparam [2:0]
        S0 = 3'b001, // Waiting for '1'
        S1 = 3'b010, // Detected '1'
        S2 = 3'b100; // Detected "10"

    reg [2:0] current_state, next_state;

    // State register with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next state logic: combinational based on current_state and input x
    always @(*) begin
        case (current_state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Output logic: Mealy output depends on current_state and input
    always @(*) begin
        // Assert z = 1 only if in S2 and x=1 (detect "101")
        z = (current_state == S2 && x) ? 1'b1 : 1'b0;
    end

endmodule