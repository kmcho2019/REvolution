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

    // Shift register for last 3 w inputs
    reg [2:0] w_shift_reg, next_w_shift_reg;

    // 2-bit counter to count number of w inputs received in B state (0 to 3)
    reg [1:0] cycle_cnt, next_cycle_cnt;

    // Register to hold the next z output
    reg next_z;

    // Combinational logic for state transitions and outputs
    always @(*) begin
        // Defaults - hold values
        next_state = state;
        next_w_shift_reg = w_shift_reg;
        next_cycle_cnt = cycle_cnt;
        next_z = 1'b0;

        case (state)
            A: begin
                next_z = 1'b0;
                next_w_shift_reg = 3'b000;
                next_cycle_cnt = 2'd0;
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                // Shift in new w value on each cycle
                next_w_shift_reg = {w_shift_reg[1:0], w};

                if (cycle_cnt == 2'd2) begin
                    // After 3rd w input shifted in, check if exactly two bits are 1
                    // Sum bits of w_shift_reg plus current w (as it's already shifted in)
                    // Actually, after shifting, w_shift_reg contains the latest three bits
                    // Count ones in next_w_shift_reg

                    // Count number of ones in next_w_shift_reg
                    integer i;
                    integer ones_count;
                    ones_count = 0;
                    for (i=0; i<3; i=i+1) begin
                        ones_count = ones_count + next_w_shift_reg[i];
                    end

                    // Output z=1 if exactly two ones, else 0
                    if (ones_count == 2)
                        next_z = 1'b1;
                    else
                        next_z = 1'b0;

                    // Reset cycle counter for next window
                    next_cycle_cnt = 2'd0;
                end else begin
                    next_z = 1'b0;
                    next_cycle_cnt = cycle_cnt + 2'd1;
                end

                next_state = B; // Remain in B indefinitely
            end
        endcase
    end

    // Sequential logic for state and outputs with synchronous active high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_shift_reg <= 3'b000;
            cycle_cnt <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            w_shift_reg <= next_w_shift_reg;
            cycle_cnt <= next_cycle_cnt;
            z <= next_z;
        end
    end

endmodule