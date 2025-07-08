module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding
    typedef enum reg [2:0] {
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5
    } state_t;

    state_t current_state, next_state;

    // Next state logic and output logic
    always @(*) begin
        case (current_state)
            A: begin
                if (w == 1'b0)
                    next_state = B;
                else
                    next_state = A;
                z = 1'b0;
            end
            B: begin
                if (w == 1'b0)
                    next_state = C;
                else
                    next_state = D;
                z = 1'b0;
            end
            C: begin
                if (w == 1'b0)
                    next_state = E;
                else
                    next_state = D;
                z = 1'b0;
            end
            D: begin
                if (w == 1'b0)
                    next_state = F;
                else
                    next_state = A;
                z = 1'b0;
            end
            E: begin
                if (w == 1'b0)
                    next_state = E;
                else
                    next_state = D;
                z = 1'b1;
            end
            F: begin
                if (w == 1'b0)
                    next_state = C;
                else
                    next_state = D;
                z = 1'b1;
            end
            default: begin
                next_state = A;
                z = 1'b0;
            end
        endcase
    end

    // Sequential logic for state register
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

endmodule