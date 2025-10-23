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

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            A: begin
                if (w == 1'b0) next_state = B;
                else           next_state = A;
            end
            B: begin
                if (w == 1'b0) next_state = C;
                else           next_state = D;
            end
            C: begin
                if (w == 1'b0) next_state = E;
                else           next_state = D;
            end
            D: begin
                if (w == 1'b0) next_state = F;
                else           next_state = A;
            end
            E: begin
                if (w == 1'b0) next_state = E;
                else           next_state = D;
            end
            F: begin
                if (w == 1'b0) next_state = C;
                else           next_state = D;
            end
            default: next_state = A;
        endcase
    end

    // State and output register (synchronous)
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 1'b0;
        end else begin
            state <= next_state;
            // Output z is 1 only if in E or F and w=1 at clock edge
            if ((state == E || state == F) && w == 1'b1)
                z <= 1'b1;
            else
                z <= 1'b0;
        end
    end

endmodule