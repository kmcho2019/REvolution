module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    typedef enum logic {A, B} state_t;
    state_t state;

    reg [1:0] cycle_cnt;    // 0..2 cycles in window
    reg [1:0] w_accum;      // counts number of w=1 in current window
    reg z_gen;              // combinational candidate for z output, registered next cycle

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z <= 1'b0;
            z_gen <= 1'b0;
        end else begin
            case(state)
                A: begin
                    z <= 1'b0;
                    z_gen <= 1'b0;
                    cycle_cnt <= 2'd0;
                    w_accum <= 2'd0;
                    if (s)
                        state <= B;
                end
                B: begin
                    // Accumulate w count and increment cycle count only in B
                    w_accum <= w_accum + w;
                    if (cycle_cnt == 2) begin
                        // After 3rd cycle, generate z in next cycle
                        z <= z_gen;
                        z_gen <= (w_accum + w == 2);
                        cycle_cnt <= 2'd0;
                        w_accum <= 2'd0;
                    end else begin
                        cycle_cnt <= cycle_cnt + 1;
                        z <= z_gen;
                        z_gen <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule