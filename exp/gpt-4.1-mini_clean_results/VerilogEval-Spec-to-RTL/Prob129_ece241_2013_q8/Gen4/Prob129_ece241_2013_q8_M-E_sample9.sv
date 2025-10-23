module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output reg z
);

    // State definitions
    localparam [1:0] 
        S0 = 2'b00, // No matched bits yet
        S1 = 2'b01, // Matched '1'
        S2 = 2'b10; // Matched "10"

    reg [1:0] current_state, next_state;

    // Asynchronous negative edge reset with synchronous state update
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next state logic: purely combinational
    always @(*) begin
        case (current_state)
            S0: next_state = (x) ? S1 : S0;
            S1: next_state = (~x) ? S2 : S1;
            S2: next_state = (x) ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Output logic: Mealy output z depends on current state and input
    always @(*) begin
        if (current_state == S2 && x)
            z = 1'b1; // Sequence "101" detected
        else
            z = 1'b0;
    end

endmodule