module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // One-hot state encoding for 3 states
    // S0 = 3'b001: waiting for '1'
    // S1 = 3'b010: matched '1'
    // S2 = 3'b100: matched "10"
    localparam S0 = 3'b001;
    localparam S1 = 3'b010;
    localparam S2 = 3'b100;

    reg [2:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (x)
                    next_state = S1;   // still matched '1'
                else
                    next_state = S2;   // matched "10"
            end
            S2: begin
                if (x)
                    next_state = S1;   // sequence "101" detected, restart matching '1'
                else
                    next_state = S0;   // reset to waiting for '1'
            end
            default: next_state = S0;
        endcase
    end

    // Output logic (Mealy) - z asserted when current state is S2 and x == 1 (sequence "101" detected)
    always @(*) begin
        z = (state == S2) && x;
    end

    // Sequential logic with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule