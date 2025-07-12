module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]   i;          // shift count (0 to 17)
    reg         done_r;
    reg [15:0]  areg;       // multiplicand register (a)
    reg [15:0]  breg;       // multiplier register (b)
    reg [31:0]  yout_r;     // product accumulator

    wire [31:0] breg_shifted;

    // Shift the multiplier left by (i-1) for addition, zero if i==0
    assign breg_shifted = (i == 0) ? 32'd0 : ({{16{1'b0}}, breg} << (i-1));

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
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                // Load inputs and clear accumulator
                areg   <= ain;
                breg   <= bin;
                yout_r <= 32'd0;
            end else if (i >= 5'd1 && i <= 5'd16) begin
                // If bit (i-1) of areg is 1, accumulate shifted breg
                if (areg[i-1])
                    yout_r <= yout_r + breg_shifted;
                else
                    yout_r <= yout_r;
            end else begin
                // Hold value when i == 17 or others
                yout_r <= yout_r;
            end
        end else begin
            // Clear registers if start == 0
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule