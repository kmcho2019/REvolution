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
    reg [1:0] cycle_cnt;  // counts 0..2 cycles in B
    reg [1:0] w_accum;    // accumulates number of w=1 in current 3-cycle window

    // Output register stage for z
    reg z_next;

    // Combinational logic for whether to assert z in next cycle
    wire z_condition;
    assign z_condition = (state == B) && (cycle_cnt == 2) && ((w_accum + w) == 2);

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z <= 1'b0;
            z_next <= 1'b0;
        end else begin
            case(state)
                A: begin
                    z <= 1'b0;
                    z_next <= 1'b0;
                    cycle_cnt <= 2'd0;
                    w_accum <= 2'd0;
                    if (s)
                        state <= B;
                    else
                        state <= A;
                end

                B: begin
                    z <= z_next;  // output z registered one cycle after counting window

                    // Update cycle count and accumulator
                    if (cycle_cnt == 2) begin
                        cycle_cnt <= 2'd0;
                        w_accum <= 2'd0;
                    end else begin
                        cycle_cnt <= cycle_cnt + 1;
                        w_accum <= w_accum + w;
                    end

                    z_next <= z_condition;

                    // Remain in B indefinitely as per spec
                    state <= B;
                end

                default: begin
                    // Defensive: reset to state A on unknown state
                    state <= A;
                    cycle_cnt <= 2'd0;
                    w_accum <= 2'd0;
                    z <= 1'b0;
                    z_next <= 1'b0;
                end
            endcase
        end
    end

endmodule