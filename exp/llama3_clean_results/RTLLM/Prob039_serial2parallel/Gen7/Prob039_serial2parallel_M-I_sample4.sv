module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [2:0] cnt; // Reduced counter width to 3 bits
reg [7:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        shift_reg <= 8'b00000000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        shift_reg <= {shift_reg[6:0], din_serial}; // Shift operation
        cnt <= cnt + 1'b1;
        if (cnt == 3'b111) begin // All 8 bits received
            cnt <= 3'b000; // Reset counter
            dout_parallel <= shift_reg; // Update dout_parallel
            dout_valid <= 1'b1; // Set dout_valid high
        end else begin
            dout_valid <= 1'b0; // Otherwise, keep dout_valid low
        end
    end else begin
        cnt <= cnt;
        shift_reg <= shift_reg;
        dout_valid <= 1'b0; // Reset dout_valid on invalid input
    end
end

endmodule