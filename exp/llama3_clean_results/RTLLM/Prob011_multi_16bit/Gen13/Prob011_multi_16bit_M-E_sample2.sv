module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [31:0] product;
reg [15:0] areg, breg;
reg [4:0] i;
reg done_r;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        product <= 0;
        areg <= 0;
        breg <= 0;
        i <= 0;
        done_r <= 0;
    end else begin
        if (start) begin
            areg <= ain;
            breg <= bin;
            i <= 0;
            done_r <= 0;
        end
        if (i < 16) begin
            product <= product + (breg * (areg[i] ? (1 << i) : 0));
            i <= i + 1;
        end
        if (i == 16) begin
            done_r <= 1;
        end
    end
end

always @(posedge clk) begin
    yout <= product;
    done <= done_r;
end

endmodule