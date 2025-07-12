module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    typedef enum logic [0:0] {A = 1'b0, B = 1'b1} state_t;
    state_t state, next_state;

    reg [1:0] cycle_cnt, next_cycle_cnt;
    reg [2:0] w_shift, next_w_shift;

    // Combinational logic for counting ones in 3-bit w_shift
    function automatic [1:0] count_ones(input [2:0] bits);
        count_ones = bits[0] + bits[1] + bits[2];
    endfunction

    // Next-state logic and combinational updates
    always @(*) begin
        // Defaults to hold current values
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_shift = w_shift;
        z = 1'b0;

        case (state)
            A: begin
                // In state A, output z=0, reset counters
                next_cycle_cnt = 2'd0;
                next_w_shift = 3'b000;
                z = 1'b0;
                if (s)
                    next_state = B;
            end
            B: begin
                // Shift in new w
                next_w_shift = {w_shift[1:0], w};

                if (cycle_cnt == 2) begin
                    // On completing 3 cycles, check if exactly two w=1
                    if (count_ones(next_w_shift) == 2)
                        z = 1'b1;
                    else
                        z = 1'b0;
                    next_cycle_cnt = 2'd0;
                end else begin
                    next_cycle_cnt = cycle_cnt + 1'b1;
                    z = 1'b0;
                end

                next_state = B;
            end
            default: begin
                next_state = A;
                next_cycle_cnt = 2'd0;
                next_w_shift = 3'b000;
                z = 1'b0;
            end
        endcase
    end

    // Sequential state, counters, and output update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_shift <= 3'b000;
            z <= 1'b0;
        end else begin
            state <= next_state;
            cycle_cnt <= next_cycle_cnt;
            w_shift <= next_w_shift;
            z <= z;
        end
    end

endmodule