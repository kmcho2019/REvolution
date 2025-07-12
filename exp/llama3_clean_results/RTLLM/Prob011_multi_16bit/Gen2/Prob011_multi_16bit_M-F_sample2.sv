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
reg start_sync; // Synchronized start signal

// Synchronize start signal with clock
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        start_sync <= 0;
    end else begin
        start_sync <= start;
    end
end

// State machine and registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i <= 0;
        done_r <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
    end else if (start_sync) begin
        if (i == 0) begin
            areg <= ain;
            breg <= bin;
            yout_r <= 0;
            i <= 1;
        end else if (i < 16) begin
            if (areg[i-1]) begin
                yout_r <= yout_r + (breg << (i-1));
            end
            i <= i + 1;
        end else if (i == 16) begin
            done_r <= 1;
            i <= 17;
        end else begin
            i <= 0;
            done_r <= 0;
        end
    end else begin
        i <= 0;
        done_r <= 0;
    end
end

// Output assignments
assign yout = yout_r;
assign done = done_r;

endmodule