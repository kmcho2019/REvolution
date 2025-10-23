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
    reg [1:0] cycle_cnt; // counts 0 to 2
    reg [1:0] w_accum;   // counts number of w=1 occurrences in window

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
                end
                B: begin
                    // Accumulate w count and cycle count
                    w_accum <= w_accum + w;
                    cycle_cnt <= cycle_cnt + 2'd1;

                    if (cycle_cnt == 2) begin
                        // After 3 cycles (cycle_cnt 0,1,2), output z next cycle
                        z <= (w_accum + w) == 2;
                        cycle_cnt <= 2'd0;
                        w_accum <= 2'd0;
                    end else begin
                        z <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule