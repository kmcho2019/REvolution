module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

// Define the pipeline stages
reg [3:0] ain_seg1, ain_seg2, ain_seg3, ain_seg4;
reg [3:0] bin_seg1, bin_seg2, bin_seg3, bin_seg4;
reg [7:0] partial_product1, partial_product2, partial_product3, partial_product4;
reg [15:0] partial_sum1, partial_sum2;
reg [31:0] product;

// Input stage
always @(posedge clk) begin
    if (!rst_n) begin
        ain_seg1 <= 4'd0;
        ain_seg2 <= 4'd0;
        ain_seg3 <= 4'd0;
        ain_seg4 <= 4'd0;
        bin_seg1 <= 4'd0;
        bin_seg2 <= 4'd0;
        bin_seg3 <= 4'd0;
        bin_seg4 <= 4'd0;
    end else if (start) begin
        ain_seg1 <= ain[3:0];
        ain_seg2 <= ain[7:4];
        ain_seg3 <= ain[11:8];
        ain_seg4 <= ain[15:12];
        bin_seg1 <= bin[3:0];
        bin_seg2 <= bin[7:4];
        bin_seg3 <= bin[11:8];
        bin_seg4 <= bin[15:12];
    end
end

// Partial product generation stage
always @(posedge clk) begin
    if (!rst_n) begin
        partial_product1 <= 8'd0;
        partial_product2 <= 8'd0;
        partial_product3 <= 8'd0;
        partial_product4 <= 8'd0;
    end else begin
        partial_product1 <= ain_seg1 * bin_seg1;
        partial_product2 <= ain_seg2 * bin_seg2;
        partial_product3 <= ain_seg3 * bin_seg3;
        partial_product4 <= ain_seg4 * bin_seg4;
    end
end

// Partial sum generation stage
always @(posedge clk) begin
    if (!rst_n) begin
        partial_sum1 <= 16'd0;
        partial_sum2 <= 16'd0;
    end else begin
        partial_sum1 <= partial_product1 + partial_product2;
        partial_sum2 <= partial_product3 + partial_product4;
    end
end

// Output stage
always @(posedge clk) begin
    if (!rst_n) begin
        product <= 32'd0;
        done <= 1'b0;
    end else if (start) begin
        product <= {partial_sum2, partial_sum1};
        done <= 1'b1;
    end else begin
        done <= 1'b0;
    end
end

assign yout = product;

endmodule