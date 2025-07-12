module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot state encoding: B=01, A=10
    reg [1:0] state, next_state;

    always @(*) begin
        case(state)
            2'b01: // B state
                if (in == 1'b0)
                    next_state = 2'b10; // go to A
                else
                    next_state = 2'b01; // stay in B
            2'b10: // A state
                if (in == 1'b0)
                    next_state = 2'b01; // go to B
                else
                    next_state = 2'b10; // stay in A
            default:
                next_state = 2'b01; // default to B if invalid
        endcase
    end

    always @(posedge clk) begin
        if (reset)
            state <= 2'b01; // reset to B
        else
            state <= next_state;
    end

    assign out = state[0]; // out=1 when in B (state[0]=1)

endmodule