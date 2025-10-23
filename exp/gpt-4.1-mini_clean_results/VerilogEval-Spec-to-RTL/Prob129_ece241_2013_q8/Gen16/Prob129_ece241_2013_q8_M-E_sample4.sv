module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output reg z
);

    // One-hot state encoding for 3 states
    // S0 = 3'b001 (initial state)
    // S1 = 3'b010
    // S2 = 3'b100
    reg [2:0] state, next_state;

    // State bits for readability
    wire s0 = state[0];
    wire s1 = state[1];
    wire s2 = state[2];

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            3'b001: // S0
                if (x)
                    next_state = 3'b010; // S1
                else
                    next_state = 3'b001; // stay S0
            3'b010: // S1
                if (x)
                    next_state = 3'b010; // stay S1
                else
                    next_state = 3'b100; // S2
            3'b100: // S2
                if (x)
                    next_state = 3'b010; // S1 (overlap)
                else
                    next_state = 3'b001; // S0
            default:
                next_state = 3'b001; // reset state
        endcase
    end

    // Output logic (Mealy): z=1 when sequence "101" detected
    // This happens on transition from S2 to S1 with x=1
    always @(*) begin
        z = (s2 && x);
    end

    // State register with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= 3'b001; // S0
        else
            state <= next_state;
    end

endmodule