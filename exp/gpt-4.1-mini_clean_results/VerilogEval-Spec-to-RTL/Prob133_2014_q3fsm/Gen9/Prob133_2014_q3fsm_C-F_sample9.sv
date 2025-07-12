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

    // Packed 4-bit register: [3:2]=w_accum, [1:0]=cycle_cnt
    reg [3:0] cnt_accum, next_cnt_accum;

    // Extract counters for convenience
    wire [1:0] cycle_cnt = cnt_accum[1:0];
    wire [1:0] w_accum = cnt_accum[3:2];

    reg next_z;

    // Combinational logic for next state, counters, and output
    always @(*) begin
        // Defaults to avoid latches and unnecessary toggling
        next_state = state;
        next_cnt_accum = cnt_accum;
        next_z = z;  // Hold previous output by default

        case (state)
            A: begin
                // In reset/wait state, counters and output zeroed
                next_cnt_accum = 4'd0;
                next_z = 1'b0;
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                next_state = B;

                if (cycle_cnt == 2) begin
                    // End of 3-cycle window; include current w in sum for output
                    next_z = ((w_accum + w) == 2);
                    // Reset counters for next window
                    next_cnt_accum = 4'd0;
                end else begin
                    // Counting cycle and accumulating w's
                    next_cnt_accum[1:0] = cycle_cnt + 2'd1;
                    next_cnt_accum[3:2] = w_accum + w;
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

    // Sequential logic: state, counters, output register update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cnt_accum <= 4'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
            // Update cnt_accum only in state B to minimize switching in A
            if (next_state == B)
                cnt_accum <= next_cnt_accum;
            else
                cnt_accum <= 4'd0;
        end
    end

endmodule