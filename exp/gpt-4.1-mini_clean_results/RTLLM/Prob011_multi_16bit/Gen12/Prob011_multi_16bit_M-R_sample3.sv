module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output          done
);

    reg [4:0]  i;            // shift count: 0 to 17 (17 states, but 0..16 active)
    reg [15:0] areg;         // multiplicand register
    reg [15:0] breg;         // multiplier register
    reg [31:0] yout_r;       // product register

    // Shift count logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 5'd0;
        else if (!start)
            i <= 5'd0;
        else if (i < 5'd17)
            i <= i + 5'd1;
    end

    // Multiplicand, multiplier, and accumulator load and update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg  <= 16'd0;
            breg  <= 16'd0;
            yout_r <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                areg  <= ain;
                breg  <= bin;
                yout_r <= 32'd0;
            end else if (i > 5'd0 && i <= 5'd16) begin
                // Check bit (i-1) of areg
                if (areg[i-1])
                    yout_r <= yout_r + ({16'd0, breg} << (i-1));
                else
                    yout_r <= yout_r;
            end
        end else begin
            // When start is not asserted, reset registers
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end
    end

    assign done = (i == 5'd16);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            yout <= 32'd0;
        else
            yout <= yout_r;
    end

endmodule