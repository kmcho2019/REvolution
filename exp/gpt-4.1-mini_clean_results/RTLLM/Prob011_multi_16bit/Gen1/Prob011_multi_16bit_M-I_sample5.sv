module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    reg [4:0] count;
    reg done_r;

    reg [31:0] accumulator;
    reg [15:0] multiplicand;
    reg [15:0] multiplier;

    // Counter and control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
        end else if (!start) begin
            count <= 5'd0;
        end else if (start && (count < 5'd16)) begin
            count <= count + 5'd1;
        end
    end

    // Done flag
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else if (count == 5'd16) begin
            done_r <= 1'b1;
        end else if (!start) begin
            done_r <= 1'b0;
        end
    end

    // Shift and accumulate
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 32'd0;
            multiplicand <= 16'd0;
            multiplier <= 16'd0;
        end else if (start) begin
            if (count == 5'd0) begin
                multiplicand <= ain;
                multiplier <= bin;
                accumulator <= 32'd0;
            end else if (count <= 5'd16) begin
                if (multiplier[0]) begin
                    accumulator <= accumulator + {16'd0, multiplicand};
                end
                multiplier <= multiplier >> 1;
                multiplicand <= multiplicand << 1;
            end
        end else begin
            // If start low, clear registers to avoid unintended operation
            accumulator <= 32'd0;
            multiplicand <= 16'd0;
            multiplier <= 16'd0;
        end
    end

    assign yout = accumulator;
    assign done = done_r;

endmodule