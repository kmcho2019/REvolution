module TopModule (
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

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            A: begin
                if (w == 1'b0) next_state = B;
                else            next_state = A;
            end
            B: begin
                if (w == 1'b0) next_state = C;
                else            next_state = D;
            end
            C: begin
                if (w == 1'b0) next_state = E;
                else            next_state = D;
            end
            D: begin
                if (w == 1'b0) next_state = F;
                else            next_state = A;
            end
            E: begin
                // In state E, input w=1 produces D, w=0 stays in E
                if (w == 1'b1) next_state = D;
                else            next_state = E;
            end
            F: begin
                // In state F, input w=1 produces D, w=0 produces C
                if (w == 1'b1) next_state = D;
                else            next_state = C;
            end
            default: next_state = A;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic: z=1 in states E and F, else 0
    always @(*) begin
        if (state == E || state == F)
            z = 1'b1;
        else
            z = 1'b0;
    end

endmodule