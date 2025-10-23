module multi_16bit(
    input           clk,
    input           rst_n,
    input           start,
    input   [15:0]  ain,
    input   [15:0]  bin,
    output  [31:0]  yout,
    output          done
);

reg [15:0] areg;
reg [15:0] breg;
reg [31:0] yout_r;
reg [4:0]   i;
reg         done_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 5'd0;
    end else if (start) begin
        if (i < 5'd17) begin
            i <= i + 1'd1;
        end
    end else begin
        i <= 5'd0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        done_r <= 1'd0;
    end else begin
        if (i == 5'd16) begin
            done_r <= 1'd1;
        end else if (i == 5'd17) begin
            done_r <= 1'd0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
    end else if (start) begin
        if (i == 5'd1) begin
            areg <= ain;
            breg <= bin;
            yout_r <= 32'd0;
        end else if (i > 5'd1 && i < 5'd17) begin
            if (areg[i-2]) begin
                yout_r <= yout_r + (breg << (i-2));
            end
        end
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule