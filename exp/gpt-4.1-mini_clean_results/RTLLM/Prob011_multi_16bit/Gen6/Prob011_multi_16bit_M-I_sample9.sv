module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]    i;          // shift count register (0 to 16)
    reg          done_r;

    reg [15:0]   areg;       // multiplicand shift register
    reg [31:0]   breg;       // multiplier shifted left accordingly
    reg [31:0]   yout_r;     // accumulator register (partial product)
    reg [31:0]   adder_out;  // combinational adder output
    reg [31:0]   yout_r_pipe;// pipelined accumulator register (stage 2)

    // Enable registers only when multiplication is active (start asserted and count in range)
    wire reg_en = start && (i <= 5'd16);

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 5'd0;
        else begin
            if (start) begin
                if (i < 5'd16)
                    i <= i + 5'd1;
            end else begin
                i <= 5'd0;
            end
        end
    end

    // Multiplication completion flag update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done_r <= 1'b0;
        else if (i == 5'd16)
            done_r <= 1'b1;
        else if (!start)
            done_r <= 1'b0;
    end

    // Load registers at start and shift/accumulate on each cycle
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg       <= 16'd0;
            breg       <= 32'd0;
            yout_r     <= 32'd0;
            yout_r_pipe<= 32'd0;
        end else if (reg_en) begin
            if (i == 5'd0) begin
                // Load inputs at cycle 0
                areg       <= ain;
                breg       <= {16'd0, bin};
                yout_r     <= 32'd0;
                yout_r_pipe<= 32'd0;
            end else begin
                // Shift and accumulate
                areg       <= areg >> 1;

                // Pipeline the adder result:
                // yout_r_pipe gets adder_out from previous cycle
                yout_r_pipe <= adder_out;

                // Shift multiplier left for next bit
                breg       <= breg << 1;

                // yout_r gets yout_r_pipe from last cycle (one cycle behind adder_out)
                yout_r     <= yout_r_pipe;
            end
        end else begin
            // When not enabled, keep registers at zero to reduce toggling
            areg       <= 16'd0;
            breg       <= 32'd0;
            yout_r     <= 32'd0;
            yout_r_pipe<= 32'd0;
        end
    end

    // Combinational adder: if LSB of areg was 1 last cycle, accumulate breg into yout_r
    // Note: at cycle i, yout_r is product from i-2, yout_r_pipe from i-1, adder_out computes next sum
    // Because of pipelining, accumulation decision uses areg[0] from previous cycle,
    // but here, we use current areg[0] which was updated after shift, so to fix we 
    // use a registered version of areg LSB from previous cycle for correct timing

    reg areg_lsb_d;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            areg_lsb_d <= 1'b0;
        else if (reg_en)
            areg_lsb_d <= areg[0];
        else
            areg_lsb_d <= 1'b0;
    end

    // Adder output combinational logic
    always @(*) begin
        if (areg_lsb_d)
            adder_out = yout_r + breg;
        else
            adder_out = yout_r;
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule