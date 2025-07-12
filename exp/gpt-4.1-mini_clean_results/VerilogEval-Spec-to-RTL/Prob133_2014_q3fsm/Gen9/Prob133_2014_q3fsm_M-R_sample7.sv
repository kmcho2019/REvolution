module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    typedef enum logic [0:0] {A = 1'b0, B = 1'b1} state_t;

    state_t state, next_state;
    reg [1:0] cycle_cnt;
    reg [1:0] w_accum;
    reg z_flag; // asserts one cycle after the window evaluation

    // Combinational next-state and counters calculation
    always @(*) begin
        next_state = state;
        case(state)
            A: begin
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                next_state = B;
            end
        endcase
    end

    wire counting_enable = (state == B);

    // Next counters logic
    wire last_cycle = (cycle_cnt == 2);
    wire [1:0] w_accum_plus = w_accum + w;

    wire [1:0] next_cycle_cnt = last_cycle ? 2'd0 : cycle_cnt + 2'd1;
    wire [1:0] next_w_accum = last_cycle ? 2'd0 : w_accum_plus;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z_flag <= 1'b0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            if (counting_enable) begin
                cycle_cnt <= next_cycle_cnt;
                w_accum <= next_w_accum;
            end else begin
                cycle_cnt <= 2'd0;
                w_accum <= 2'd0;
            end

            // z_flag is set one cycle after the 3rd w sample is taken and evaluated
            if (state == B && last_cycle)
                z_flag <= (w_accum_plus == 2);
            else
                z_flag <= 1'b0;

            z <= z_flag;
        end
    end

endmodule