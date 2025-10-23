module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // States encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // 3-bit shift register to hold last three w samples
    reg [2:0] w_shift, next_w_shift;

    // 2-bit counter to count how many samples collected in state B (0 to 3)
    reg [1:0] sample_cnt, next_sample_cnt;

    reg next_z;

    // Function to count number of ones in 3-bit vector
    function [1:0] popcount3;
        input [2:0] bits;
        begin
            popcount3 = bits[0] + bits[1] + bits[2];
        end
    endfunction

    // Next state and outputs logic
    always @(*) begin
        // Defaults
        next_state = state;
        next_w_shift = w_shift;
        next_sample_cnt = sample_cnt;
        next_z = 1'b0;

        case(state)
            A: begin
                // Output zero in A, clear counters and shift register
                next_z = 1'b0;
                next_w_shift = 3'b000;
                next_sample_cnt = 2'd0;
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                // Shift in w
                next_w_shift = {w_shift[1:0], w};

                if (sample_cnt == 2) begin
                    // After collecting 3 samples (counting from 0), check condition
                    // popcount3(next_w_shift) includes current w shifted in
                    next_z = (popcount3(next_w_shift) == 2);
                    next_sample_cnt = 2'd0; // reset sample count for next window
                    next_state = B;
                end else begin
                    next_sample_cnt = sample_cnt + 1;
                    next_z = 1'b0;
                    next_state = B;
                end
            end
            default: begin
                // Default fallback to reset
                next_state = A;
                next_w_shift = 3'b000;
                next_sample_cnt = 2'd0;
                next_z = 1'b0;
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_shift <= 3'b000;
            sample_cnt <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            w_shift <= next_w_shift;
            sample_cnt <= next_sample_cnt;
            z <= next_z;
        end
    end

endmodule