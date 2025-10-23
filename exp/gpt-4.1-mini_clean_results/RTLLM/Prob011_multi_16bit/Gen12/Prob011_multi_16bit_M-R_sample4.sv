module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]  i;          // Shift count: 0 to 16
    reg [15:0] areg;       // Multiplicand register
    reg [15:0] breg;       // Multiplier register
    reg [31:0] yout_r;     // Accumulated product

    // Shift count and control logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 5'd0;
        else if (!start)
            i <= 5'd0;
        else if (start && (i < 5'd17))
            i <= i + 5'd1;
    end

    // Multiplication done flag (done = 1 when i == 16)
    assign done = (i == 5'd16);

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                // Load multiplicand and multiplier at cycle 0
                areg   <= ain;
                breg   <= bin;
                yout_r <= 32'd0;
            end else if (i <= 5'd16) begin
                // For each bit, if the current bit of breg is 1, add (areg shifted by i-1) to yout_r
                if (breg[i-1])
                    yout_r <= yout_r + ({16'd0, areg} << (i-1));
            end
        end else begin
            // If start is low, clear the registers
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end
    end

    assign yout = yout_r;

endmodule