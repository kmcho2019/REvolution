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
    reg [1:0] cycle_cnt;   // counts cycles 0..2 in state B
    reg [1:0] w_count;     // counts number of w=1 in current 3-cycle window
    reg z_pending;         // flag to hold whether to output z=1 next cycle

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_count <= 2'd0;
            z_pending <= 1'b0;
            z <= 1'b0;
        end else begin
            z <= z_pending;  // output delayed by one cycle after counting window

            case (state)
                A: begin
                    z_pending <= 1'b0;
                    cycle_cnt <= 2'd0;
                    w_count <= 2'd0;
                    if (s)
                        state <= B;
                end

                B: begin
                    if (cycle_cnt < 2) begin
                        cycle_cnt <= cycle_cnt + 1;
                        w_count <= w_count + w;
                        z_pending <= 1'b0;
                    end else begin
                        // Last cycle of window
                        w_count <= 0;
                        cycle_cnt <= 0;
                        z_pending <= (w_count + w == 2); // set output next cycle
                    end
                    // remain in state B forever
                end
            endcase
        end
    end

endmodule