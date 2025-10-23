module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // Pack cycle_cnt and w_accum in one 4-bit register:
    // bits[3:2] = w_accum (2 bits)
    // bits[1:0] = cycle_cnt (2 bits)
    reg [3:0] cnt_accum, next_cnt_accum;

    wire [1:0] cycle_cnt = cnt_accum[1:0];
    wire [1:0] w_accum = cnt_accum[3:2];

    reg next_z;

    always @(*) begin
        // Defaults
        next_state = state;
        next_cnt_accum = cnt_accum;
        next_z = 1'b0;

        case(state)
            A: begin
                next_z = 1'b0;
                next_cnt_accum = 4'd0;
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                next_state = B;

                if (cycle_cnt == 2) begin
                    // End of 3-cycle window: output in next cycle if exactly two 'w's were 1
                    next_z = ((w_accum + w) == 2);
                    next_cnt_accum = 4'd0; // reset counters for next window
                end else begin
                    // Accumulate and count cycles
                    next_cnt_accum[1:0] = cycle_cnt + 2'd1;
                    next_cnt_accum[3:2] = w_accum + w;
                    next_z = 1'b0;
                end
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cnt_accum <= 4'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;

            // Update counters only in state B to reduce toggle in state A
            if (next_state == B)
                cnt_accum <= next_cnt_accum;
            else
                cnt_accum <= 4'd0;
        end
    end

endmodule