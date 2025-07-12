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

    reg [1:0] cycle_cnt, next_cycle_cnt; // counts 0..2 for 3 cycles
    reg [2:0] w_shift, next_w_shift;     // shift register to hold last 3 w inputs

    reg z_next;

    // Function to count number of 1's in a 3-bit vector
    function [1:0] popcount3;
        input [2:0] in;
        begin
            popcount3 = in[0] + in[1] + in[2];
        end
    endfunction

    always @(*) begin
        // Defaults to hold values
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_shift = w_shift;
        z_next = 1'b0;

        case(state)
            A: begin
                next_cycle_cnt = 2'd0;
                next_w_shift = 3'b000;
                z_next = 1'b0;
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                next_state = B;
                if (cycle_cnt == 2) begin
                    // After collecting 3 w inputs in w_shift[2:0] (oldest MSB),
                    // we shift in current w and then check popcount == 2
                    // Here we consider w_shift holds previous 2 w inputs;
                    // current w is new input; so total 3 w inputs including current w.
                    // Create full 3-bit vector with shift in current w:
                    // Actually, we shift in current w this cycle, so after shifting, w_shift will have 3 latest w.

                    // For output z, count ones in w_shift after shifting in current w
                    // But since we only update w_shift next cycle, we consider current w plus previous 2 stored in w_shift[2:1]

                    // Hence, the 3-bit vector is {w_shift[1:0], w}
                    // But since w_shift is 3 bits holding previous 3 w's, the cycle count alignment is that
                    // after 3 shifts, cycle_cnt == 2 means 3 w's collected in w_shift.

                    // To keep correct alignment, we shift w into w_shift at every cycle,
                    // so at cycle_cnt == 2, w_shift already contains 3 w's inputs including current cycle

                    // Therefore, just check popcount of w_shift

                    z_next = (popcount3(w_shift) == 2);
                    next_cycle_cnt = 2'd0;
                    next_w_shift = 3'b000; // reset for next window
                end else begin
                    // Shift in current w, increment cycle count
                    next_w_shift = {w_shift[1:0], w};
                    next_cycle_cnt = cycle_cnt + 2'd1;
                    z_next = 1'b0;
                end
            end
        endcase
    end

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
            z <= z_next;
        end
    end

endmodule