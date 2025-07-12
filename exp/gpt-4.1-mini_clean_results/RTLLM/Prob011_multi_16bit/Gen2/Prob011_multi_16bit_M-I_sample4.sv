module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]    i;        // shift count register (0 to 16)
    reg          done_r;
    reg [15:0]   areg;
    reg [31:0]   breg;     // extended to 32 bits for shifting
    reg [31:0]   yout_r;

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

    // Shift and accumulate operation (serial bit-by-bit)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                areg   <= ain;
                breg   <= {16'd0, bin};  // extend bin to 32 bits
                yout_r <= 32'd0;
            end else if (i <= 5'd16) begin
                // If LSB of areg is 1, accumulate breg into product
                if (areg[0])
                    yout_r <= yout_r + breg;
                else
                    yout_r <= yout_r;
                // Shift areg right to process next bit
                areg <= areg >> 1;
                // Shift breg left to align next partial product
                breg <= breg << 1;
            end
        end else begin
            // If start is low, reset partial product and registers
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule