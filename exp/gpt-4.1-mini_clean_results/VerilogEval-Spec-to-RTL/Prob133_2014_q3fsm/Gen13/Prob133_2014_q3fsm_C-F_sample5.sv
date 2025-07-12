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
    reg [1:0] cycle_cnt, next_cycle_cnt;  // Counts 0..2 (3 cycles)
    reg [1:0] w_accum, next_w_accum;      // Counts number of w=1's in window
    reg next_z;

    // Combinational logic: Next state and counters
    always @(*) begin
        // Default assignments: hold current values
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_accum = w_accum;
        next_z = 1'b0;

        case (state)
            A: begin
                // In reset state, clear outputs and counters
                next_z = 1'b0;
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                next_state = B;
                if (cycle_cnt == 2) begin
                    // End of 3-cycle window: check if exactly two w=1's including current cycle's w
                    next_z = ((w_accum + w) == 2);
                    // Reset counters for next window
                    next_cycle_cnt = 2'd0;
                    next_w_accum = 2'd0;
                end else begin
                    next_z = 1'b0;
                    next_cycle_cnt = cycle_cnt + 2'd1;
                    next_w_accum = w_accum + w;
                end
            end
            default: begin
                // Defensive default: back to state A and clear outputs/counters
                next_state = A;
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
                next_z = 1'b0;
            end
        endcase
    end

    // Sequential logic: state and output update on positive clock edge
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
            // Update counters only in B to reduce toggling in state A
            if (next_state == B) begin
                cycle_cnt <= next_cycle_cnt;
                w_accum <= next_w_accum;
            end else begin
                cycle_cnt <= 2'd0;
                w_accum <= 2'd0;
            end
        end
    end

endmodule