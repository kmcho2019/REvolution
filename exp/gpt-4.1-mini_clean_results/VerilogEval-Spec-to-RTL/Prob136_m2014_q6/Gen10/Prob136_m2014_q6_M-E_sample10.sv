module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

    typedef enum reg [2:0] {
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5
    } state_t;

    state_t state, next_state;

    // Next-state and output logic
    always @(*) begin
        // Default assignments
        next_state = state;
        z = 1'b0;

        case(state)
            A: begin
                if (w)
                    next_state = A;
                else
                    next_state = B;
                z = 1'b0;
            end
            B: begin
                if (w)
                    next_state = D;
                else
                    next_state = C;
                z = 1'b0;
            end
            C: begin
                if (w)
                    next_state = D;
                else
                    next_state = E;
                z = 1'b0;
            end
            D: begin
                if (w)
                    next_state = A;
                else
                    next_state = F;
                z = 1'b0;
            end
            E: begin
                if (w)
                    next_state = D;
                else
                    next_state = E;
                z = 1'b1;
            end
            F: begin
                if (w)
                    next_state = D;
                else
                    next_state = C;
                z = 1'b1;
            end
            default: begin
                next_state = A;
                z = 1'b0;
            end
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

endmodule