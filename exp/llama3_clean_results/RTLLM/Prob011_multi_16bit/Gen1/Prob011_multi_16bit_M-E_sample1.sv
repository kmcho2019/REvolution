module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output [31:0] yout,
    output done
);

reg [15:0] areg, breg;
reg [31:0] yout_r;
reg [4:0] i;
reg done_r;

// Array of adders
reg [31:0] partial_products [15:0];

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
        done_r <= 1'b0;
        for (int j = 0; j < 16; j++) begin
            partial_products[j] <= 32'd0;
        end
    end else if (start) begin
        areg <= ain;
        breg <= bin;
        yout_r <= 32'd0;
        done_r <= 1'b0;
        for (int j = 0; j < 16; j++) begin
            partial_products[j] <= (breg << j) & (1 << j);
        end
    end else if (done_r == 1'b0) begin
        yout_r <= yout_r + partial_products[i];
        if (i < 15) begin
            i <= i + 1;
        end else begin
            done_r <= 1'b1;
        end
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule