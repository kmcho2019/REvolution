module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        S0 = 2'd0,  // no match
        S1 = 2'd1,  // matched '1'
        S2 = 2'd2   // matched '10'
    } state_t;

    state_t state, next_state;

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state and output logic combined in one combinational block
    always @(*) begin
        // Default assignments
        next_state = state;
        z = 1'b0;

        case (state)
            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
                z = 1'b0;
            end
            S1: begin
                if (!x)
                    next_state = S2;
                else
                    next_state = S1;
                z = 1'b0;
            end
            S2: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
                // Output asserted here for detected sequence "101"
                z = x ? 1'b1 : 1'b0;
            end
            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

endmodule