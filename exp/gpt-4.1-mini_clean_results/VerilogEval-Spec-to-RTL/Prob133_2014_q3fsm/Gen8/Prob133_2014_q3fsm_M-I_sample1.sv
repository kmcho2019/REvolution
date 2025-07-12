module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    reg [1:0] cycle_cnt;  // counts 0 to 2
    reg [1:0] w_accum;    // counts number of 1's in w over 3 cycles

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z <= 1'b0;
        end else begin
            case (state)
                A: begin
                    z <= 1'b0;
                    cycle_cnt <= 2'd0;
                    w_accum <= 2'd0;
                    if (s)
                        state <= B;
                end
                B: begin
                    // Update cycle counter and accumulator only in B
                    if (cycle_cnt == 2) begin
                        // 3rd cycle, final count
                        // Compute z: exactly two 1's in 3 cycles means w_accum + w == 2
                        z <= ((w_accum + w) == 2);
                        cycle_cnt <= 2'd0;
                        w_accum <= 2'd0;
                    end else begin
                        z <= 1'b0;
                        cycle_cnt <= cycle_cnt + 1'b1;
                        w_accum <= w_accum + w;
                    end
                end
            endcase
        end
    end

endmodule