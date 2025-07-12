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

    // 4-bit packed register: [3:2] = w_accum (2 bits), [1:0] = cycle_cnt (2 bits)
    reg [3:0] cnt_accum, next_cnt_accum;

    // z delayed by 1 cycle after 3-cycle window ends; compute next_z combinationally
    reg next_z;

    // Extract cycle count and accumulator for clarity
    wire [1:0] cycle_cnt = cnt_accum[1:0];
    wire [1:0] w_accum = cnt_accum[3:2];

    // Combinational logic for next state, counters, and z
    always @(*) begin
        // Default assignments to avoid latches
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
                    // End of 3-cycle window: z = 1 if exactly 2 of 3 w's are 1
                    // w_accum holds count from first 2 cycles, add current w for 3rd
                    next_z = ((w_accum + w) == 2);

                    // Reset counters for next window
                    next_cnt_accum = 4'd0;
                end else begin
                    // Accumulate w and increment cycle count
                    next_cnt_accum[1:0] = cycle_cnt + 2'd1;

                    // w_accum + w with saturation at 3 (max 2-bit count is 3, safe here)
                    next_cnt_accum[3:2] = w_accum + w;

                    next_z = 1'b0;
                end
            end
        endcase
    end

    // Sequential logic with synchronous reset, state and counters update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cnt_accum <= 4'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;

            // Update counters only in state B to save power (prevent toggling in A)
            if (next_state == B)
                cnt_accum <= next_cnt_accum;
            else
                cnt_accum <= 4'd0;

            // Output z is updated every cycle as per computed next_z
            z <= next_z;
        end
    end

endmodule