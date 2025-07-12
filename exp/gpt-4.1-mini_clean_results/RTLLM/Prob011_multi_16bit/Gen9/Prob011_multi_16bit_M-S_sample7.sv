module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0]  yout,
    output reg         done
);

    reg [4:0] i;            // shift count: 0 to 16
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [31:0] accumulator;

    // Shift count update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 5'd0;
        else if (!start)
            i <= 5'd0;
        else if (i < 5'd16)
            i <= i + 5'd1;
    end

    // Done flag update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done <= 1'b0;
        else if (i == 5'd16)
            done <= 1'b1;
        else if (!start)
            done <= 1'b0;
    end

    // Multiplication process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 16'd0;
            multiplier <= 16'd0;
            accumulator <= 32'd0;
            yout <= 32'd0;
        end else if (!start) begin
            multiplicand <= 16'd0;
            multiplier <= 16'd0;
            accumulator <= 32'd0;
            yout <= 32'd0;
        end else begin
            if (i == 5'd0) begin
                multiplicand <= ain;
                multiplier <= bin;
                accumulator <= 32'd0;
            end else if (i <= 5'd16) begin
                if (multiplier[0]) 
                    accumulator <= accumulator + ( {16'd0, multiplicand} << (i-1) );
                multiplier <= multiplier >> 1;
            end
            if (i == 5'd16)
                yout <= accumulator;
        end
    end

endmodule