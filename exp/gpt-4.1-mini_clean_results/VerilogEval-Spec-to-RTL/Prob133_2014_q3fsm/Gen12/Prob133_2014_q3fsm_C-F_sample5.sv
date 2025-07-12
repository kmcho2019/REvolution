module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // Packed 4-bit register: [3:2]=w_accum (2 bits), [1:0]=cycle_cnt (2 bits)
    reg [3:0] cnt_accum, next_cnt_accum;

    wire [1:0] cycle_cnt = cnt_accum[1:0];
    wire [1:0] w_accum = cnt_accum[3:2];

    reg next_z;

    // Clock enable signal for counter update (only in state B)
    wire cnt_en = (state == B);

    always @(*) begin
        // Defaults
        next_state = state;
        next_cnt_accum = cnt_accum;
        next_z = z;  // Hold previous z by default

        case (state)
            A: begin
                next_z = 1'b0;       // output zero in reset state
                next_cnt_accum = 4'd0;
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                next_state = B;

                if (cycle_cnt == 2) begin
                    // At the end of 3 cycles (counting 0..2), output depends on (w_accum + w)
                    // Exactly two w=1 in the 3-cycle window --> z=1 next cycle else 0
                    // Simple logic: sum = w_accum + w, check if equal to 2
                    // w_accum and w are 2-bit and 1-bit respectively; sum max is 3

                    next_z = ((w_accum + w) == 2);

                    // Reset counters for next 3-cycle window
                    next_cnt_accum = 4'd0;
                end else begin
                    // Increment cycle counter and accumulate w
                    // cycle_cnt + 1 mod 4 (only 0..2 used)
                    // w_accum + w (w is 0 or 1)
                    next_cnt_accum[1:0] = cycle_cnt + 2'd1;
                    next_cnt_accum[3:2] = w_accum + w;
                    next_z = 1'b0;  // output zero during counting cycles
                end
            end
            default: begin
                next_state = A;
                next_cnt_accum = 4'd0;
                next_z = 1'b0;
            end
        endcase
    end

    // Sequential logic with clock enable for counter updates to reduce toggling power
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cnt_accum <= 4'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
            if (cnt_en)
                cnt_accum <= next_cnt_accum;
            else
                cnt_accum <= 4'd0;
        end
    end

endmodule