module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg       done
);

    reg [4:0] i;                 // shift count: 0 to 17
    reg [15:0] areg;             // multiplicand register
    reg [15:0] breg;             // multiplier register
    reg [31:0] product;          // accumulation register

    // Shift count and control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else if (!start) begin
            i <= 5'd0;
        end else if (i < 5'd17) begin
            i <= i + 1'b1;
        end
    end

    // done flag generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done <= 1'b0;
        end else begin
            if (i == 5'd16)
                done <= 1'b1;
            else if (i == 5'd17)
                done <= 1'b0;
        end
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'd0;
            breg <= 16'd0;
            product <= 32'd0;
            yout <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                areg <= ain;
                breg <= bin;
                product <= 32'd0;
                yout <= 32'd0;
            end else if (i >= 5'd1 && i <= 5'd16) begin
                if (areg[i-1]) begin
                    product <= product + ({16'd0, breg} << (i - 1));
                end
                // yout updated every cycle to product for output reflect
                yout <= product;
            end else begin
                // i == 17 or beyond: hold outputs
                yout <= product;
            end
        end else begin
            // if start not asserted, reset outputs
            areg <= 16'd0;
            breg <= 16'd0;
            product <= 32'd0;
            yout <= 32'd0;
        end
    end

endmodule