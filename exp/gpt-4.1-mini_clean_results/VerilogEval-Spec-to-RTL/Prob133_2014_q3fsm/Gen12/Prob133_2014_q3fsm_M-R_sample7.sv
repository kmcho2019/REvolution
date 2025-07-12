module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    typedef enum logic [0:0] {A=1'b0, B=1'b1} state_t;

    state_t state, next_state;

    reg [1:0] cycle_cnt, next_cycle_cnt; // counts 0 to 2 for 3 cycles
    reg [1:0] w_accum, next_w_accum;     // accumulates number of w=1 in 3 cycles
    reg z_next;

    // Next state and next counter logic
    always @(*) begin
        // Defaults
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_accum = w_accum;
        z_next = 1'b0;

        case (state)
            A: begin
                z_next = 1'b0;
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                // Accumulate w and increment cycle count
                next_w_accum = w_accum + w;
                if (cycle_cnt == 2) begin
                    // After 3 cycles, output z = 1 if exactly two w=1, else 0
                    z_next = (next_w_accum == 2);
                    next_cycle_cnt = 2'd0;
                    next_w_accum = 2'd0;
                end else begin
                    next_cycle_cnt = cycle_cnt + 2'd1;
                    z_next = 1'b0;
                end
                next_state = B;
            end
            default: begin
                next_state = A;
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
                z_next = 1'b0;
            end
        endcase
    end

    // Sequential logic: registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            cycle_cnt <= next_cycle_cnt;
            w_accum <= next_w_accum;
            z <= z_next;
        end
    end

endmodule