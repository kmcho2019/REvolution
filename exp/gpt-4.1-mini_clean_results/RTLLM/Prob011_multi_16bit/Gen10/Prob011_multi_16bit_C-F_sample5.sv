module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]    i;          // Shift count: 0..17
    reg          done_r;
    reg [15:0]   areg;
    reg [31:0]   breg;       // Zero-extended multiplier, shifted left each cycle
    reg [31:0]   yout_r;

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else if (start) begin
            if (i < 5'd17)
                i <= i + 5'd1;
            else
                i <= i; // Hold at 17 until start deasserted
        end else begin
            i <= 5'd0;
        end
    end

    // Done flag update: set when i == 16, clear at i == 17 or start deasserted
    always @(posedge clk or negedge rst_n) begin
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

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
        end else if (start) begin
            case (i)
                5'd0: begin
                    // Load inputs at cycle 0
                    areg   <= ain;
                    breg   <= {16'd0, bin}; // zero-extend multiplier to 32 bits
                    yout_r <= 32'd0;
                end

                // Multiplication cycles: i from 1 to 16
                5'd1, 5'd2, 5'd3, 5'd4, 5'd5, 5'd6, 5'd7,
                5'd8, 5'd9, 5'd10, 5'd11, 5'd12, 5'd13,
                5'd14, 5'd15, 5'd16: begin
                    // Accumulate only if LSB of areg is 1
                    if (areg[0])
                        yout_r <= yout_r + breg;
                    else
                        yout_r <= yout_r; // no change

                    // Shift multiplicand right for next bit
                    areg <= areg >> 1;

                    // Shift multiplier left to align with next bit
                    breg <= breg << 1;
                end

                5'd17: begin
                    // Hold stable after multiplication completes
                    areg   <= areg;
                    breg   <= breg;
                    yout_r <= yout_r;
                end

                default: begin
                    // Safeguard: hold registers stable if out-of-range i
                    areg   <= areg;
                    breg   <= breg;
                    yout_r <= yout_r;
                end
            endcase
        end else begin
            // When start is low, reset internal registers to zero
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule