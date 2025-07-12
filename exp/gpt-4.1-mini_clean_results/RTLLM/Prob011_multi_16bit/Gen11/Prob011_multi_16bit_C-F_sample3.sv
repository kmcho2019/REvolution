module multi_16bit (
    input          clk,
    input          rst_n,    // synchronous active-low reset
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]    i;          // shift count: 0..17
    reg          done_r;
    reg [15:0]   areg;
    reg [31:0]   breg;
    reg [31:0]   yout_r;

    wire         add_en;
    wire [31:0]  add_res;

    // Counter i update
    always @(posedge clk) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else if (start) begin
            if (i < 5'd17)
                i <= i + 5'd1;
            else
                i <= i; // hold at 17 while start is asserted
        end else begin
            i <= 5'd0; // reset counter when start is deasserted
        end
    end

    // Done flag update
    always @(posedge clk) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else if (i == 5'd16) begin
            done_r <= 1'b1;
        end else if (i == 5'd17 || !start) begin
            done_r <= 1'b0;
        end else begin
            done_r <= done_r;
        end
    end

    // Addition enable: when start is active, in multiplication cycles (1..16), and LSB of areg is 1
    assign add_en = (start && (i >= 5'd1) && (i <= 5'd16) && areg[0]);

    // Combinational addition result
    assign add_res = yout_r + breg;

    // Shift and accumulate operation with clock enables and synchronous reset
    always @(posedge clk) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                // Load multiplicand and zero-extend multiplier at start
                areg   <= ain;
                breg   <= {16'd0, bin};
                yout_r <= 32'd0;
            end else if ((i >= 5'd1) && (i <= 5'd16)) begin
                // Conditional accumulation and shift
                if (add_en)
                    yout_r <= add_res; // update with addition result
                else
                    yout_r <= yout_r;  // hold current product

                areg <= areg >> 1;
                breg <= breg << 1;
            end else begin
                // Hold registers stable at i == 17 (operation done)
                areg   <= areg;
                breg   <= breg;
                yout_r <= yout_r;
            end
        end else begin
            // When start is low, hold previous values to minimize toggling
            areg   <= areg;
            breg   <= breg;
            yout_r <= yout_r;
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule