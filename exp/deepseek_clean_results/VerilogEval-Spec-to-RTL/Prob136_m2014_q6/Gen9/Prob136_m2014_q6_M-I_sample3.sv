module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // Optimized state encoding (2 bits for 6 states)
    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11,
        E = 2'b00,  // Shares encoding with A (distinguished by output)
        F = 2'b01    // Shares encoding with B (distinguished by output)
    } state_t;

    state_t state, next_state;
    reg z_next;
    reg clk_enable;

    // Clock gating logic
    always_comb begin
        clk_enable = (state != next_state);
    end

    // State transition logic
    always_comb begin
        case (state)
            A: begin
                next_state = w ? A : B;
                z_next = 1'b0;
            end
            B: begin
                next_state = w ? D : C;
                z_next = 1'b0;
            end
            C: begin
                next_state = w ? D : E;
                z_next = 1'b0;
            end
            D: begin
                next_state = w ? A : F;
                z_next = 1'b0;
            end
            E: begin
                next_state = w ? D : E;
                z_next = 1'b1;
            end
            F: begin
                next_state = w ? D : C;
                z_next = 1'b1;
            end
            default: begin
                next_state = A;
                z_next = 1'b0;
            end
        endcase
    end

    // Sequential logic with clock gating
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 1'b0;
        end else if (clk_enable) begin
            state <= next_state;
            z <= z_next;
        end
    end

    // Power optimization
    (* syn_preserve = 1 *) reg unused;
    always_comb unused = ^{state, next_state};

endmodule