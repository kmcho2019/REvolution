module multi_16bit_pipelined(
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

// Input Stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        areg <= 0;
        breg <= 0;
    end else if (start && (i == 0)) begin
        areg <= ain;
        breg <= bin;
    end
end

// Shift Stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 0;
    end else if (start && (i < 16)) begin
        i <= i + 1;
    end else if (start && (i == 16)) begin
        i <= 0;
    end
end

// Accumulate Stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        yout_r <= 0;
    end else if (start && (i > 0 && i < 17)) begin
        if (breg[0]) begin
            yout_r <= yout_r + (areg << (i-1));
        end
        breg <= breg >> 1;
    end
end

// Multiply Stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        done_r <= 0;
    end else if (start && (i == 16)) begin
        done_r <= 1;
    end else if (start && (i == 17)) begin
        done_r <= 0;
    end
end

// Output Stage
assign yout = yout_r;
assign done = done_r;

endmodule