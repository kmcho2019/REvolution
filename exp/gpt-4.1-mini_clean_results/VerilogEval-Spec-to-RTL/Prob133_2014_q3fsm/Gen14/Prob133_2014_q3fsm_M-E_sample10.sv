module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // States definition
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    reg [1:0] cycle_cnt, next_cycle_cnt;    // count cycles 0..2 in state B
    reg [2:0] w_shift, next_w_shift;        // shift register to hold last 3 w samples

    reg z_next;

    // Combinational logic for popcount of 3 bits
    wire [1:0] popcount;
    assign popcount = w_shift[0] + w_shift[1] + w_shift[2];

    always @(*) begin
        // defaults
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_shift = w_shift;
        z_next = 1'b0;

        case (state)
            A: begin
                // reset counters and outputs
                next_cycle_cnt = 2'd0;
                next_w_shift = 3'b000;
                z_next = 1'b0;
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                // shift in current w
                next_w_shift = {w_shift[1:0], w};

                if (cycle_cnt == 2) begin
                    // On 3rd cycle, compute popcount over w_shift + current w (which is already shifted in next_w_shift)
                    // popcount is combinational on next_w_shift
                    z_next = (popcount == 2);
                    next_cycle_cnt = 2'd0;     // restart counting for next 3-cycle window
                    next_w_shift = 3'b000;     // clear shift register for next window
                    next_state = B;
                end else begin
                    // increment cycle count, no output this cycle
                    next_cycle_cnt = cycle_cnt + 2'd1;
                    z_next = 1'b0;
                    next_state = B;
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