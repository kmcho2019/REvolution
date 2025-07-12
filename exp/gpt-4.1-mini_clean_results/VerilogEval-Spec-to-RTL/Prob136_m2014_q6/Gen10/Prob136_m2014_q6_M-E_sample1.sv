module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    typedef enum logic [2:0] {
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5
    } state_t;

    state_t state, next_state;
    logic next_z;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
        end
    end

    always_comb begin
        case (state)
            A: begin
                next_z = 1'b0;
                if (w)
                    next_state = A;
                else
                    next_state = B;
            end
            B: begin
                next_z = 1'b0;
                if (w)
                    next_state = D;
                else
                    next_state = C;
            end
            C: begin
                next_z = 1'b0;
                if (w)
                    next_state = D;
                else
                    next_state = E;
            end
            D: begin
                next_z = 1'b0;
                if (w)
                    next_state = A;
                else
                    next_state = F;
            end
            E: begin
                next_z = 1'b1;
                if (w)
                    next_state = D;
                else
                    next_state = E;
            end
            F: begin
                next_z = 1'b1;
                if (w)
                    next_state = D;
                else
                    next_state = C;
            end
            default: begin
                next_z = 1'b0;
                next_state = A;
            end
        endcase
    end

endmodule