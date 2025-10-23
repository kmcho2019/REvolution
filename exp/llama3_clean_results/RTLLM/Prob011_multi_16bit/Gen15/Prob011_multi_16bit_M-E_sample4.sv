module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [31:0] partial_product [3:0];
reg [1:0] segment;
reg [3:0] i;
reg [31:0] yout_r;
reg done_r;

always @(posedge clk) begin
    if (!rst_n) begin
        segment <= 2'd0;
        i <= 4'd0;
        yout_r <= 32'd0;
        done_r <= 1'b0;
        partial_product[0] <= 32'd0;
        partial_product[1] <= 32'd0;
        partial_product[2] <= 32'd0;
        partial_product[3] <= 32'd0;
    end else begin
        if (start) begin
            if (segment < 2'd4) begin
                // Calculate partial product for current segment
                case (segment)
                    2'd0: partial_product[0] <= {16'd0, ain[3:0]} * bin;
                    2'd1: partial_product[1] <= {16'd0, ain[7:4]} * bin;
                    2'd2: partial_product[2] <= {16'd0, ain[11:8]} * bin;
                    2'd3: partial_product[3] <= {16'd0, ain[15:12]} * bin;
                endcase
                // Shift and accumulate partial products
                if (segment > 2'd0) begin
                    case (segment)
                        2'd1: yout_r <= yout_r + partial_product[0] << 4;
                        2'd2: yout_r <= yout_r + partial_product[1] << 8;
                        2'd3: yout_r <= yout_r + partial_product[2] << 12;
                    endcase
                end else begin
                    yout_r <= partial_product[0];
                end
                segment <= segment + 1'b1;
            end else begin
                // Finalize product and set done flag
                yout_r <= yout_r + partial_product[3] << 16;
                done_r <= 1'b1;
            end
        end else begin
            segment <= 2'd0;
            i <= 4'd0;
            yout_r <= 32'd0;
            done_r <= 1'b0;
            partial_product[0] <= 32'd0;
            partial_product[1] <= 32'd0;
            partial_product[2] <= 32'd0;
            partial_product[3] <= 32'd0;
        end
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule