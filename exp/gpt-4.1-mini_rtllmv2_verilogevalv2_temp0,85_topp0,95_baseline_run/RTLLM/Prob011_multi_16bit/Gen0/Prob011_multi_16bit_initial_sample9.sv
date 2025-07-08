module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [4:0] i;                // shift count register (0 to 17 max)
    reg [15:0] areg;            // multiplicand register
    reg [15:0] breg;            // multiplier register
    reg [31:0] yout_r;          // product register
    reg done_r;                 // done flag register

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else begin
            if (!start)
                i <= 5'd0;
            else if (i < 5'd17)
                i <= i + 5'd1;
        end
    end

    // Done flag update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else begin
            if (i == 5'd16)
                done_r <= 1'b1;
            else if (i == 5'd17)
                done_r <= 1'b0;
        end
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'd0;
            breg <= 16'd0;
            yout_r <= 32'd0;
        end else begin
            if (start) begin
                if (i == 5'd0) begin
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 32'd0;
                end else if (i >= 5'd1 && i <= 5'd16) begin
                    // If bit (i-1) of areg is 1, add breg shifted by (i-1) to yout_r
                    if (areg[i-1])
                        yout_r <= yout_r + ({16'd0, breg} << (i-1));
                end
            end else begin
                // If start is not asserted, reset product register
                yout_r <= 32'd0;
                areg <= 16'd0;
                breg <= 16'd0;
            end
        end
    end

    // Output assignments
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            yout <= 32'd0;
        else
            yout <= yout_r;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done <= 1'b0;
        else
            done <= done_r;
    end

endmodule