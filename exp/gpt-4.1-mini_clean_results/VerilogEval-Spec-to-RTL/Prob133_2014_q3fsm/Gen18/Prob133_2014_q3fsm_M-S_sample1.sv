module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    reg [2:0] w_sum_cnt; // 3 bits: bits [1:0] for cycle count (0-2), bit [2] accumulates w counts

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_sum_cnt <= 3'd0;
            z <= 1'b0;
        end else begin
            case(state)
                A: begin
                    z <= 1'b0;
                    w_sum_cnt <= 3'd0;
                    if (s)
                        state <= B;
                end
                B: begin
                    if (w_sum_cnt[1:0] == 2) begin
                        // On 3rd cycle: total w count = accumulated count + current w
                        // accumulated count stored in bit [2] and possibly others? We use a 3-bit to store sum and count.
                        // Instead, we separate counting and sum to simplify.

                        // Since the single register approach with combined sum and count is tricky,
                        // here we separate counting and summing as bits [1:0]: cycle count, bit [2]: w count

                        // Calculate total w count: w_count + current w
                        // w_count = w_sum_cnt[2] (number of w=1s counted so far)
                        // cycle count: w_sum_cnt[1:0]

                        // output z one cycle after counting the 3 cycles, so in next clock cycle
                        // To do this simply, output z here based on previous sum, and reset counters

                        z <= ((w_sum_cnt[2] + w) == 2);
                        w_sum_cnt <= 3'd0;
                    end else begin
                        // Accumulate w count and increment cycle count
                        // w_sum_cnt[2]: number of w=1 counted so far
                        // w_sum_cnt[1:0]: cycle count 0..2
                        w_sum_cnt <= {w_sum_cnt[2] + w, w_sum_cnt[1:0] + 1'b1};
                        z <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule