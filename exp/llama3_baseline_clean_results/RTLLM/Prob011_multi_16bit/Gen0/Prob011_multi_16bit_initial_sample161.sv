module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output [31:0] yout,
    output done
);

reg [15:0] areg;
reg [15:0] breg;
reg [31:0] yout_r;
reg [4:0] i;
reg done_r;

assign yout = yout_r;
assign done = done_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        areg <= 16'h0;
        breg <= 16'h0;
        yout_r <= 32'h0;
        i <= 5'h0;
        done_r <= 1'b0;
    end else begin
        if (start) begin
            if (i == 5'h0) begin
                areg <= ain;
                breg <= bin;
                yout_r <= 32'h0;
            end else if (i < 5'h11) begin
                if (areg[15 - i]) begin
                    yout_r <= yout_r + (breg << (i - 1));
                end
            end
            if (i < 5'h10) begin
                areg <= {1'b0, areg[15:1]};
                i <= i + 5'h1;
            end else if (i == 5'h10) begin
                i <= i + 5'h1;
                done_r <= 1'b1;
            end else if (i == 5'h11) begin
                i <= 5'h0;
                done_r <= 1'b0;
            end
        end else begin
            i <= 5'h0;
            done_r <= 1'b0;
        end
    end
end

endmodule