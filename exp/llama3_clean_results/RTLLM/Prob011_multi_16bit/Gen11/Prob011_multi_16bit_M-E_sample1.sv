module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [15:0] areg;
reg [15:0] breg;
reg [31:0] prod_reg;
reg [4:0] count;
reg start_pulse;
reg done_r;
reg [31:0] yout_r;

always @(posedge clk) begin
    if (!rst_n) begin
        areg <= 16'd0;
        breg <= 16'd0;
        prod_reg <= 32'd0;
        count <= 5'd0;
        start_pulse <= 1'b0;
        done_r <= 1'b0;
        yout_r <= 32'd0;
    end else begin
        // Input Stage
        if (start) begin
            areg <= ain;
            breg <= bin;
            start_pulse <= 1'b1;
        end

        // Shift Stage
        if (start_pulse && count < 5'd16) begin
            prod_reg <= prod_reg + (breg << count);
            count <= count + 1'b1;
        end

        // Multiply-accumulate Stage
        if (count == 5'd16) begin
            done_r <= 1'b1;
        end

        // Output Stage
        if (done_r) begin
            yout_r <= prod_reg;
        end
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule