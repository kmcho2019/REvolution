module multi_16bit (
    input          clk,
    input          rst_n,   // active-low synchronous reset
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    localparam IDLE      = 5'd0;
    localparam MAX_COUNT = 5'd16;

    reg [4:0]    i;         // shift count (0 to 16)
    reg [15:0]   areg;
    reg [31:0]   breg;
    reg [31:0]   yout_r;

    wire         running;
    wire         add_en;
    wire [31:0]  add_res;

    // Multiplication is running while start is active and count <= 16
    assign running = start && (i <= MAX_COUNT);

    // Enable addition if running, and current LSB of areg is 1, and count > 0
    assign add_en = running && (i != 0) && (areg[0] == 1'b1);

    // Combinational adder result (only meaningful when add_en)
    assign add_res = yout_r + breg;

    // Counter: counts from 0 to 16 when start asserted; resets to 0 otherwise
    always @(posedge clk) begin
        if (!rst_n)
            i <= IDLE;
        else if (start) begin
            if (i < MAX_COUNT + 1)
                i <= i + 1'b1;
            else
                i <= i; // hold at MAX_COUNT + 1 until start deasserted
        end
        else
            i <= IDLE;
    end

    // Shift and accumulate
    always @(posedge clk) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
        end
        else if (start) begin
            if (i == 0) begin
                // Load multiplicand and multiplier at start
                areg   <= ain;
                breg   <= {16'd0, bin}; // zero extend multiplier to 32 bits
                yout_r <= 32'd0;
            end
            else if (i <= MAX_COUNT) begin
                // Accumulate if bit set
                yout_r <= add_en ? add_res : yout_r;

                // Shift areg right by 1 to get next bit
                areg   <= areg >> 1;

                // Shift breg left by 1 only when adding (to align for next bit)
                // But shift left every cycle to match classical shift-and-add algorithm:
                // Actually, better to shift breg left each cycle to line up multiplier bits correctly.
                breg   <= breg << 1;
            end
            else begin
                // After multiplication completes, hold values
                areg   <= areg;
                breg   <= breg;
                yout_r <= yout_r;
            end
        end
        else begin
            // Hold values when not started to avoid glitches/toggling
            areg   <= areg;
            breg   <= breg;
            yout_r <= yout_r;
        end
    end

    // Done flag is combinational: asserted when i == MAX_COUNT and start active
    assign done = (i == MAX_COUNT) && start;

    assign yout = yout_r;

endmodule