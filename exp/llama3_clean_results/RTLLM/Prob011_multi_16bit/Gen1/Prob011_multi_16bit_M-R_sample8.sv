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

// State machine
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i <= 0;
        done_r <= 0;
    end else if (start) begin
        if (i < 16) begin
            i <= i + 1;
        end else if (i == 16) begin
            i <= 0;
            done_r <= 1;
        end
    end else begin
        i <= 0;
        done_r <= 0;
    end
end

// Multiplicand and multiplier registers
always @(posedge clk) begin
    if (start && i == 0) begin
        areg <= ain;
        breg <= bin;
    end
end

// Product register
always @(posedge clk) begin
    if (start && i > 0 && i < 17) begin
        if (areg[i-1]) begin
            yout_r <= yout_r + (breg << (i-1));
        end
    end else if (~start || i == 0) begin
        yout_r <= 0;
    end
end

// Reset registers
always @(negedge rst_n) begin
    areg <= 0;
    breg <= 0;
    yout_r <= 0;
end

// Output assignments
assign yout = yout_r;
assign done = done_r;

endmodule