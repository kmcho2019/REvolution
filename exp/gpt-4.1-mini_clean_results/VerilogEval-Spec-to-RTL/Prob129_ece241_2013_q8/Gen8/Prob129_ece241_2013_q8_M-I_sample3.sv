module TopModule (
    input        clk,
    input        aresetn,
    input        x,
    output reg   z
);

    // One-hot encoding for 3 states
    // S0 = 3'b001 (initial)
    // S1 = 3'b010
    // S2 = 3'b100
    reg [2:0] state, next_state;

    localparam S0 = 3'b001;
    localparam S1 = 3'b010;
    localparam S2 = 3'b100;

    // Next state logic - combinational
    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Sequential block - state update and output z
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            state <= next_state;

            // Mealy output z asserted when sequence "101" detected
            // The "101" is detected when in S2 and input x=1 (transition to S1)
            if (state == S2 && x)
                z <= 1'b1;
            else
                z <= 1'b0;
        end
    end

endmodule