module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [4:0] i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 5'd0;
        yout <= 32'd0;
        done <= 1'b0;
    end else begin
        if (start && i < 5'd16) begin
            if (i == 5'd0) begin
                yout <= 32'd0;
            end else if (ain[i-1] == 1'b1) begin
                yout <= yout + (bin << (i-1));
            end
            i <= i + 1'b1;
            if (i == 5'd16) begin
                done <= 1'b1;
            end
        end else begin
            i <= 5'd0;
            yout <= 32'd0;
            done <= 1'b0;
        end
    end
end

endmodule