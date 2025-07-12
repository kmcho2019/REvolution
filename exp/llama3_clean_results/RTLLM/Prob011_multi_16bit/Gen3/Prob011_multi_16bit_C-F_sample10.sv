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
reg [4:0] i;
reg done_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 0;
        done_r <= 0;
        areg <= 0;
        breg <= 0;
        yout <= 0;
    end else begin
        if (start && (i == 0)) begin
            areg <= ain;
            breg <= bin;
            yout <= 0;
            i <= 1;
        end else if (start && (i > 0 && i < 17)) begin
            if (areg[i-1]) begin
                yout <= yout + (breg << (i-1));
            end
            i <= i + 1;
            if (i == 16) begin
                done_r <= 1;
            end
        end else if (start && (i == 17)) begin
            done_r <= 0;
            i <= 0;
        end else if (!start) begin
            i <= 0;
            done_r <= 0;
            areg <= 0;
            breg <= 0;
            yout <= 0;
        end
    end
end

assign done = done_r;

endmodule