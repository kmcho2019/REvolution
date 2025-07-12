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

    reg [1:0] cycle_cnt, next_cycle_cnt;    // counts from 0 to 2 (3 cycles)
    reg [1:0] w_accum, next_w_accum;        // accumulate count of w=1 in 3 cycles

    reg flag_two_w;       // flagged when exactly two w=1 detected after 3 cycles
    reg flag_two_w_d;     // delayed flag to register output z

    // Next state and counters combinational logic
    always @(*) begin
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_accum = w_accum;
        flag_two_w = 1'b0;  // default

        case(state)
            A: begin
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
                    // After 3 cycles (0,1,2), check if exactly two w=1 detected
                    if ((w_accum + w) == 2)
                        flag_two_w = 1'b1;
                    else
                        flag_two_w = 1'b0;

                    next_cycle_cnt = 2'd0;
                    next_w_accum = 2'd0;
                end else begin
                    flag_two_w = 1'b0;
                    next_cycle_cnt = cycle_cnt + 1;
                    next_w_accum = w_accum + w;
                end
            end
        endcase
    end

    // Sequential logic: state, counters, flags, and output z
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            flag_two_w_d <= 1'b0;
            z <= 1'b0;
        end else begin
            state <= next_state;

            if (state == B) begin
                cycle_cnt <= next_cycle_cnt;
                w_accum <= next_w_accum;
            end else begin
                cycle_cnt <= 2'd0;
                w_accum <= 2'd0;
            end

            flag_two_w_d <= flag_two_w;  // register the detection flag
            z <= flag_two_w_d;           // output registered with one cycle delay after 3-cycle window
        end
    end

endmodule