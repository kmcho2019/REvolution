module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // One-hot state encoding: 3 states -> 3 bits
    localparam S0 = 3'b001; // no bits matched
    localparam S1 = 3'b010; // matched '1'
    localparam S2 = 3'b100; // matched '10'

    reg [2:0] state, next_state;

    // Next state and output logic (Mealy FSM)
    always @(*) begin
        // Default assignments
        next_state = S0;
        z = 1'b0;

        case (1'b1) // One-hot encoded states: match on '1'
            state[0]: begin // S0
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end
            state[1]: begin // S1
                if (x)
                    next_state = S1;
                else
                    next_state = S2;
            end
            state[2]: begin // S2
                if (x) begin
                    next_state = S1;
                    z = 1'b1; // "101" detected
                end else
                    next_state = S0;
            end
            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

    // State register with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule