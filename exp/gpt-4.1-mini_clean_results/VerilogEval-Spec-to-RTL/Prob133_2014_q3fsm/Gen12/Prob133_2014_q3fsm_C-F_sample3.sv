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

    // Packed 4-bit register for cycle count and w accumulator:
    // bits[3:2] = w_accum (2 bits)
    // bits[1:0] = cycle_cnt (2 bits)
    reg [3:0] cnt_accum, next_cnt_accum;

    wire [1:0] cycle_cnt = cnt_accum[1:0];
    wire [1:0] w_accum = cnt_accum[3:2];

    reg next_z;

    always @(*) begin
        // Default assignments to avoid latches
        next_state = state;
        next_cnt_accum = cnt_accum;
        next_z = 1'b0;

        case(state)
            A: begin
                next_cnt_accum = 4'd0; // reset counters
                next_z = 1'b0;
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                next_state = B;

                if (cycle_cnt == 2) begin
                    // End of 3-cycle window: decide z for next cycle
                    // Total w count = w_accum + current w
                    // Output z=1 if exactly two 'w's in the 3 cycles
                    next_z = ((w_accum + w) == 2);
                    next_cnt_accum = 4'd0; // reset counters for next window
                end else begin
                    // Increment cycle count
                    next_cnt_accum[1:0] = cycle_cnt + 2'd1;

                    // Increment w_accum by w (w is single bit, so conditional increment)
                    if (w)
                        next_cnt_accum[3:2] = w_accum + 2'd1;
                    else
                        next_cnt_accum[3:2] = w_accum;

                    next_z = 1'b0;
                end
            end
            default: begin
                next_state = A;
                next_cnt_accum = 4'd0;
                next_z = 1'b0;
            end
        endcase
    end

    // Sequential block with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cnt_accum <= 4'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;

            // Update counters only in state B to reduce toggling and save power
            if (next_state == B)
                cnt_accum <= next_cnt_accum;
            else
                cnt_accum <= 4'd0;
        end
    end

endmodule