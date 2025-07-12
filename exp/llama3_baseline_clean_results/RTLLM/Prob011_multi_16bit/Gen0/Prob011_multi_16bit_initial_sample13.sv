module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [3:0] i; // shift count register
reg [15:0] areg; // multiplicand register
reg [15:0] breg; // multiplier register
reg [31:0] yout_r; // product register
reg done_r; // multiplication completion flag

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 4'd0;
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
        done_r <= 1'b0;
    end else begin
        if (start) begin
            if (i == 4'd0) begin
                areg <= ain;
                breg <= bin;
            end
            if (i < 4'd16) begin
                i <= i + 1;
            end
            if (i == 4'd16) begin
                done_r <= 1'b1;
            end else if (i == 4'd17) begin
                i <= 4'd0;
                done_r <= 1'b0;
            end
            if (areg[15 - i] == 1'b1) begin
                yout_r <= yout_r + (breg << (i - 1));
            end
        end else begin
            i <= 4'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            yout_r <= 32'd0;
            done_r <= 1'b0;
        end
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule