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

    reg state;
    reg [1:0] cycle_cnt;  // counts 0..2 for 3 cycles
    reg [1:0] w_count;    // counts number of w=1 inputs in current group
    reg z_next;

    // Auxiliary register to hold condition to assert z next cycle
    reg z_assert;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'b00;
            w_count <= 2'b00;
            z <= 1'b0;
            z_assert <= 1'b0;
        end else begin
            case(state)
                A: begin
                    z <= 1'b0;
                    z_assert <= 1'b0;
                    cycle_cnt <= 2'b00;
                    w_count <= 2'b00;
                    if (s)
                        state <= B;
                end

                B: begin
                    z <= z_assert; // output is asserted one cycle after evaluation
                    z_assert <= 1'b0; // default no assertion unless set below

                    if (cycle_cnt == 2) begin
                        // On 3rd cycle, evaluate if exactly two w=1 in the 3-cycle window
                        if ((w_count + w) == 2)
                            z_assert <= 1'b1;
                        else
                            z_assert <= 1'b0;

                        // Reset counters for next group
                        cycle_cnt <= 2'b00;
                        w_count <= 2'b00;
                    end else begin
                        cycle_cnt <= cycle_cnt + 1'b1;
                        w_count <= w_count + w;
                    end
                    // Remain in B
                    state <= B;
                end
            endcase
        end
    end

endmodule