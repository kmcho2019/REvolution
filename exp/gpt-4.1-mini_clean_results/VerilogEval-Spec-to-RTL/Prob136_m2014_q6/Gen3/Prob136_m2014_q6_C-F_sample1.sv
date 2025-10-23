module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire w,
    output wire z
);

    // State encoding with typedef enum for clarity
    typedef enum logic [2:0] {
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5
    } state_t;

    state_t state, next_state;

    // Next state and output combinational logic combined for clarity
    // Although output is assigned separately as continuous assign, this block focuses on next state only.
    always @(*) begin
        case(state)
            A: begin
                if (w == 1'b0)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                if (w == 1'b0)
                    next_state = C;
                else
                    next_state = D;
            end

            C: begin
                if (w == 1'b0)
                    next_state = E;
                else
                    next_state = D;
            end

            D: begin
                if (w == 1'b0)
                    next_state = F;
                else
                    next_state = A;
            end

            E: begin
                if (w == 1'b0)
                    next_state = E;
                else
                    next_state = D;
            end

            F: begin
                if (w == 1'b0)
                    next_state = C;
                else
                    next_state = D;
            end

            default: next_state = A;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output z combinationally derived from current state (Moore machine)
    assign z = (state == E) || (state == F);

endmodule