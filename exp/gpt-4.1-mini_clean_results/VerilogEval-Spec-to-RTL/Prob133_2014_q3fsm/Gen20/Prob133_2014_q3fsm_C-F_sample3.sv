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
    reg [1:0] cycle_cnt;  // 0..2 for counting 3 cycles
    reg [1:0] w_accum;    // count how many w=1 in current 3-cycle window

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z <= 1'b0;
        end else begin
            case(state)
                A: begin
                    z <= 1'b0;
                    cycle_cnt <= 2'd0;
                    w_accum <= 2'd0;
                    if (s)
                        state <= B;
                    else
                        state <= A;
                end

                B: begin
                    if (cycle_cnt == 2) begin
                        // After 3rd w input, output z in this cycle:
                        // z=1 if exactly two of the three w's are 1 (including current w)
                        z <= ((w_accum + w) == 2);
                        cycle_cnt <= 2'd0;
                        w_accum <= 2'd0;
                    end else begin
                        z <= 1'b0;
                        cycle_cnt <= cycle_cnt + 2'd1;
                        // Increment w_accum only if w=1
                        w_accum <= w_accum + (w ? 2'd1 : 2'd0);
                    end
                    state <= B;
                end

                default: begin
                    // Defensive: reset to known state
                    state <= A;
                    cycle_cnt <= 2'd0;
                    w_accum <= 2'd0;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule