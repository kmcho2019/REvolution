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
    reg [1:0] cycle_cnt;
    reg [1:0] w_accum;

    reg z_next;

    // Next state logic
    always @(*) begin
        case (state)
            A: begin
                if (s)
                    z_next = 1'b0;
                else
                    z_next = 1'b0;
            end
            B: begin
                z_next = 1'b0;
            end
            default: z_next = 1'b0;
        endcase
    end

    // Next state calculation and output logic in one combinational block
    reg next_state;
    reg out_z_next;

    always @(*) begin
        next_state = state;
        out_z_next = 1'b0;
        case (state)
            A: begin
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (cycle_cnt == 2) begin
                    // after counting 3 cycles, check if w=1 exactly twice
                    out_z_next = ((w_accum + w) == 2);
                    next_state = B;
                end else begin
                    out_z_next = 1'b0;
                    next_state = B;
                end
            end
            default: next_state = A;
        endcase
    end

    // Sequential block: update state, counters, and output
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= out_z_next;

            if (next_state == B) begin
                if (cycle_cnt == 2) begin
                    // reset counters after 3 cycles
                    cycle_cnt <= 2'd0;
                    w_accum <= 2'd0;
                end else begin
                    cycle_cnt <= cycle_cnt + 2'd1;
                    w_accum <= w_accum + (w ? 2'd1 : 2'd0);
                end
            end else begin
                cycle_cnt <= 2'd0;
                w_accum <= 2'd0;
            end
        end
    end

endmodule