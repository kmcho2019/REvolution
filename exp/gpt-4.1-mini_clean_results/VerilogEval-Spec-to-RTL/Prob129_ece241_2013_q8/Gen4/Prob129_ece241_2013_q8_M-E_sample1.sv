module TopModule(
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // One-hot state definitions
    parameter S0 = 3'b001; // initial state, no match
    parameter S1 = 3'b010; // matched '1'
    parameter S2 = 3'b100; // matched '10'

    reg [2:0] state, next_state;

    // Next state and output combinational logic
    always @(*) begin
        // default assignments
        next_state = 3'b000;
        z = 1'b0;

        case (state)
            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                if (x)
                    next_state = S1; // stay on S1 because input '1' again
                else
                    next_state = S2; // matched "10"
            end

            S2: begin
                if (x) begin
                    next_state = S1; // prepare for next possible match
                    z = 1'b1;        // detected "101"
                end else
                    next_state = S0;
            end

            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

    // State register with async negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule