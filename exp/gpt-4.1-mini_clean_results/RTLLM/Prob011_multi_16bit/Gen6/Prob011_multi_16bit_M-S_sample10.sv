module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg       done
);

    reg [4:0] i;             // Shift count: 0 to 16
    reg [31:0] acc;          // Accumulator for product

    // Shift count and done flag management
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i    <= 5'd0;
            done <= 1'b0;
        end else if (!start) begin
            i    <= 5'd0;
            done <= 1'b0;
        end else if (i < 5'd16) begin
            i <= i + 5'd1;
            done <= 1'b0;
        end else if (i == 5'd16) begin
            done <= 1'b1;
        end
    end

    // Accumulate partial sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc  <= 32'd0;
            yout <= 32'd0;
        end else if (!start) begin
            acc  <= 32'd0;
            yout <= 32'd0;
        end else begin
            if (i == 5'd0) begin
                acc <= 32'd0;  // Clear accumulator at start
            end else if (i <= 5'd16) begin
                if (bin[i-1]) begin
                    acc <= acc + ( {16'd0, ain} << (i-1) );
                end
            end
            if (i == 5'd16) begin
                yout <= acc;
            end
        end
    end

endmodule