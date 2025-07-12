module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [4:0] i; // shift count register
reg [15:0] areg; // multiplicand register
reg [15:0] breg; // multiplier register
reg [31:0] yout_r; // product register
reg done_r; // multiplication completion flag

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        done_r <= 0;
    end else begin
        if (start && i < 16) begin
            if (i == 0) begin
                areg <= ain;
                breg <= bin;
            end
            if (areg[i-1] == 1 && i > 0) begin
                yout_r <= yout_r + (breg << (i-1));
            end
            i <= i + 1;
        end else if (~start) begin
            i <= 0;
        end
        if (i == 16) begin
            done_r <= 1;
        end else if (i == 17) begin
            done_r <= 0;
            i <= 0;
        end
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule