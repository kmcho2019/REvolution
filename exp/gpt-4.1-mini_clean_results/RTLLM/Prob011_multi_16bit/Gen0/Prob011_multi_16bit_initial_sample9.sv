module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [4:0] i;            // shift count (0 to 17)
    reg [15:0] areg;        // multiplicand register
    reg [15:0] breg;        // multiplier register
    reg [31:0] yout_r;      // product register
    reg done_r;             // done flag register

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 5'd0;
        else if (start && (i < 5'd17))
            i <= i + 5'd1;
        else if (!start)
            i <= 5'd0;
    end

    // Done flag update
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
            areg <= 16'd0;
            breg <= 16'd0;
            yout_r <= 32'd0;
        end
        else if (start) begin
            if (i == 5'd0) begin
                areg <= ain;
                breg <= bin;
                yout_r <= 32'd0;
            end
            else if ((i > 5'd0) && (i < 5'd17)) begin
                // if bit (i-1) of areg is set, add (breg shifted left by i-1)
                if (areg[i-1])
                    yout_r <= yout_r + ( {16'd0, breg} << (i-1) );
            end
        end
        else begin
            areg <= 16'd0;
            breg <= 16'd0;
            yout_r <= 32'd0;
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