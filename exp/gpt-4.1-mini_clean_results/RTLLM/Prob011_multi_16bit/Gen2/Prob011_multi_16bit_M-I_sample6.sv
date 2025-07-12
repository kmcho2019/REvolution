module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]    i;          // shift count (0 to 17)
    reg          done_r;
    reg [15:0]   areg;
    reg [31:0]   breg_ext;   // extended multiplier shifted left progressively
    reg [31:0]   yout_r;

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 5'd0;
        else if (start) begin
            if (i < 5'd17)
                i <= i + 5'd1;
        end else
            i <= 5'd0;
    end

    // done flag update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done_r <= 1'b0;
        else if (i == 5'd16)
            done_r <= 1'b1;
        else if (i == 5'd17)
            done_r <= 1'b0;
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg_ext <= 32'd0;
            yout_r <= 32'd0;
        end else if (start) begin
            case (i)
                5'd0: begin
                    // Load inputs and clear accumulator
                    areg   <= ain;
                    breg_ext <= {16'd0, bin}; // zero-extend multiplier
                    yout_r <= 32'd0;
                end
                5'd1, 5'd2, 5'd3, 5'd4, 5'd5, 5'd6, 5'd7, 5'd8,
                5'd9, 5'd10, 5'd11, 5'd12, 5'd13, 5'd14, 5'd15, 5'd16: begin
                    // If LSB of areg is 1, add breg_ext to yout_r
                    if (areg[0])
                        yout_r <= yout_r + breg_ext;
                    else
                        yout_r <= yout_r;

                    // Shift areg right to process next bit next cycle
                    areg <= areg >> 1;
                    // Shift breg_ext left by 1 to correspond to multiplier bit position
                    breg_ext <= breg_ext << 1;
                end
                default: begin
                    // Hold registers when i == 17 or else
                    areg <= areg;
                    breg_ext <= breg_ext;
                    yout_r <= yout_r;
                end
            endcase
        end else begin
            // Clear all registers if start == 0
            areg <= 16'd0;
            breg_ext <= 32'd0;
            yout_r <= 32'd0;
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule