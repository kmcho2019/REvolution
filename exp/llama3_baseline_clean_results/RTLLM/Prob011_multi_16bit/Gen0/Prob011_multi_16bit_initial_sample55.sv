module multi_16bit(
    input clk, rst_n, start,
    input [15:0] ain, bin,
    output reg [31:0] yout,
    output reg done
);

reg [4:0] i;  // Shift count register
reg [15:0] areg;  // Multiplicand register
reg [15:0] breg;  // Multiplier register
reg [31:0] yout_r;  // Product register
reg done_r;  // Multiplication completion flag

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 0;
        done_r <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
    end else begin
        if (start) begin
            if (i < 17) begin
                i <= i + 1;
            end
            if (i == 0) begin
                areg <= ain;
                breg <= bin;
            end
            if (i > 0 && i < 17) begin
                if (areg[15 - (i - 1)]) begin
                    yout_r <= yout_r + (breg << (i - 1));
                end
            end
        end else begin
            i <= 0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        done_r <= 0;
    end else begin
        if (i == 16) begin
            done_r <= 1;
        end else if (i == 17) begin
            done_r <= 0;
        end
    end
end

always @(*) begin
    yout = yout_r;
    done = done_r;
end

endmodule