module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // One-hot state encoding for 3 states
    localparam S0 = 3'b001; // no bits matched
    localparam S1 = 3'b010; // matched '1'
    localparam S2 = 3'b100; // matched '10'

    reg [2:0] state, next_state;

    // Sequential logic: state update with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational logic: next state and Mealy output z generation
    always @(*) begin
        // Default values
        next_state = S0;
        z = 1'b0;

        case (1'b1)  // one-hot state decoding
            state[0]: begin // S0
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end

            state[1]: begin // S1
                if (!x)
                    next_state = S2;
                else
                    next_state = S1;
            end

            state[2]: begin // S2
                if (x) begin
                    next_state = S1;
                    z = 1'b1; // sequence '101' detected here
                end else
                    next_state = S0;
            end

            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

endmodule