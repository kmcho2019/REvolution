module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [31:0] partial_products [15:0];
reg [31:0] sum;
reg [4:0] count;
reg done_r;

assign yout = sum;
assign done = done_r;

always @(posedge clk) begin
    if (!rst_n) begin
        sum <= 32'd0;
        count <= 5'd0;
        done_r <= 1'b0;
    end else begin
        if (start && count == 5'd0) begin
            for (int i = 0; i < 16; i++) begin
                if (bin[i] == 1'b1) begin
                    partial_products[i] <= {16'd0, ain} << i;
                end else begin
                    partial_products[i] <= 32'd0;
                end
            end
            count <= 5'd1;
        end else if (count == 5'd1) begin
            sum <= 32'd0;
            for (int i = 0; i < 16; i++) begin
                sum <= sum + partial_products[i];
            end
            count <= 5'd2;
        end else if (count == 5'd2) begin
            done_r <= 1'b1;
        end else if (done_r) begin
            count <= 5'd0;
            done_r <= 1'b0;
        end
    end
end

endmodule