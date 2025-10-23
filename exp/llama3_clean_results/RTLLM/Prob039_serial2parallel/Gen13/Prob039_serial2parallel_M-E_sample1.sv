module serial2parallel_lfsr (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [7:0] lfsr; // 8-bit Linear Feedback Shift Register
reg [2:0] cnt;  // 3-bit counter to keep track of the number of bits received

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
    end else if (din_valid) begin
        if (cnt < 3'b1000) begin
            cnt <= cnt + 1'b1;
        end else begin
            cnt <= 3'b000;
        end
    end
end

// LFSR logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        lfsr <= 8'b00000000;
    end else if (din_valid) begin
        lfsr <= {lfsr[6:0], din_serial};
    end
end

// Output logic
always @(posedge clk) begin
    if (cnt == 3'b1000) begin
        dout_parallel <= lfsr;
        dout_valid <= 1'b1;
    end else begin
        dout_valid <= 1'b0;
    end
end

endmodule