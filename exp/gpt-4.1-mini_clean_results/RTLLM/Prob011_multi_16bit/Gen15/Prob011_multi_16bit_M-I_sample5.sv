module multi_16bit (
    input          clk,
    input          rst_n,   // synchronous active-low reset
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]    i;          // Shift count: 0..17
    reg          done_r;
    reg [15:0]   areg;
    reg [31:0]   breg;
    reg [31:0]   yout_r;

    wire         active;     // Multiplication active signal
    wire         add_en;     // Addition enable signal
    wire [31:0]  add_res;

    // Multiplication active during counting from 0 up to 16 inclusive
    assign active = start && (i <= 5'd16);

    // Addition enable: active during cycles 1..16 and areg LSB = 1
    assign add_en = active && (i >= 5'd1) && areg[0];

    // Compute addition only when add_en is high; else tie to yout_r
    assign add_res = add_en ? (yout_r + breg) : yout_r;

    // Counter update with clock enable to reduce toggling
    always @(posedge clk) begin
        if (!rst_n)
            i <= 5'd0;
        else if (start) begin
            if (i < 5'd17)
                i <= i + 5'd1;
            else
                i <= i; // hold at 17 until start deasserted
        end
        else
            i <= i; // hold count when not started
    end

    // Done flag update synchronous
    always @(posedge clk) begin
        if (!rst_n)
            done_r <= 1'b0;
        else if (i == 5'd16)
            done_r <= 1'b1;
        else if (i == 5'd17 || !start)
            done_r <= 1'b0;
        else
            done_r <= done_r;
    end

    // Shift and accumulate operation with enable signals
    always @(posedge clk) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
        end
        else if (start) begin
            if (i == 5'd0) begin
                // Load inputs at start of operation
                areg   <= ain;
                breg   <= {16'd0, bin}; // zero extend multiplier
                yout_r <= 32'd0;
            end
            else if ((i >= 5'd1) && (i <= 5'd16)) begin
                // Update yout_r only if addition is enabled
                if (add_en)
                    yout_r <= add_res;
                else
                    yout_r <= yout_r; // hold

                // Shift areg and breg only during active multiplication cycles
                areg <= areg >> 1;
                breg <= breg << 1;
            end
            else begin
                // Hold registers after multiplication finishes
                areg   <= areg;
                breg   <= breg;
                yout_r <= yout_r;
            end
        end
        else begin
            // Hold previous values when not started, avoid resetting
            areg   <= areg;
            breg   <= breg;
            yout_r <= yout_r;
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule