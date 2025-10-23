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

    wire         i_en;
    wire         done_en;
    wire         reg_en;
    wire         add_en;

    // Enable signal for counter 'i'
    assign i_en = start && (i < 5'd17);

    // Enable signal for done flag update
    assign done_en = (i == 5'd16) || (i == 5'd17) || (!start);

    // Enable signal for registers (areg, breg, yout_r)
    assign reg_en = start && ((i == 5'd0) || ((i >= 5'd1) && (i <= 5'd16)));

    // Enable for addition operation
    // Only add when in multiplication cycles and areg LSB is 1
    assign add_en = (start && (i >= 5'd1) && (i <= 5'd16) && areg[0]);

    // Operand B for adder is gated by add_en to reduce toggling
    wire [31:0] add_operand_b = add_en ? breg : 32'd0;

    // Compute sum combinationally with gated operand to reduce switching
    wire [31:0] add_res = yout_r + add_operand_b;

    // Counter update with synchronous reset and enable
    always @(posedge clk) begin
        if (!rst_n)
            i <= 5'd0;
        else if (i_en)
            i <= i + 5'd1;
        else if (!start)
            i <= 5'd0;
        else
            i <= i; // hold when not enabled
    end

    // Done flag update synchronous with enable
    always @(posedge clk) begin
        if (!rst_n)
            done_r <= 1'b0;
        else if (done_en) begin
            if (i == 5'd16)
                done_r <= 1'b1;
            else
                done_r <= 1'b0;
        end else
            done_r <= done_r;
    end

    // Shift and accumulate operation with enable and synchronous reset
    always @(posedge clk) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
        end else if (reg_en) begin
            if (i == 5'd0) begin
                // Load inputs at start of operation
                areg   <= ain;
                breg   <= {16'd0, bin}; // zero extend multiplier
                yout_r <= 32'd0;
            end else begin
                // Accumulate conditionally
                if (add_en)
                    yout_r <= add_res;
                else
                    yout_r <= yout_r;
                // Shift areg right and breg left each cycle (except i==0)
                areg <= areg >> 1;
                breg <= breg << 1;
            end
        end else begin
            // Hold previous values when not enabled (including when start is low)
            areg   <= areg;
            breg   <= breg;
            yout_r <= yout_r;
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule