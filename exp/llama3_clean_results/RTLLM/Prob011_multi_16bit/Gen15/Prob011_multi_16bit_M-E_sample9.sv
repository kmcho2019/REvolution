module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [31:0] partial_product;
reg [15:0] shifted_ain;
reg [4:0] i;
reg [31:0] yout_r;
reg done_r;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        partial_product <= 0;
        shifted_ain <= 0;
        i <= 0;
        yout_r <= 0;
        done_r <= 0;
    end else if (start) begin
        partial_product <= 0;
        shifted_ain <= ain;
        i <= 0;
        done_r <= 0;
    end else if (i < 16) begin
        if (bin[i] == 1'b1) begin
            partial_product <= partial_product + shifted_ain;
        end
        shifted_ain <= shifted_ain << 1;
        i <= i + 1;
    end else begin
        yout_r <= partial_product;
        done_r <= 1;
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule