module TopModule(
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // Define states using typedef enum for clarity
    typedef enum logic [1:0] {
        S0 = 2'd0, // no match
        S1 = 2'd1, // matched '1'
        S2 = 2'd2  // matched '10'
    } state_t;

    state_t state, next_state;
    reg z_next;

    // Next state logic and output z generation (combinational)
    always @(*) begin
        next_state = state;
        z_next = 1'b0;
        case (state)
            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S2;
            end
            S2: begin
                if (x) begin
                    next_state = S1;
                    z_next = 1'b1; // "101" detected
                end else
                    next_state = S0;
            end
            default: begin
                next_state = S0;
                z_next = 1'b0;
            end
        endcase
    end

    // State and output registers with async negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= z_next;
        end
    end

endmodule