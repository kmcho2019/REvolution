module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [2:0] cnt; // 3-bit counter to keep track of the number of serial input data bits received
reg [7:0] shift_reg; // 8-bit shift register to store the incoming serial data

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        shift_reg <= 8'b00000000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        if (cnt < 3'b100) begin
            // Shift the existing bits in the shift register one position to the left
            shift_reg <= {shift_reg[6:0], din_serial};
            cnt <= cnt + 1'b1;
        end else begin
            cnt <= 3'b000;
            shift_reg <= 8'b00000000;
        end
    end
end

always @(posedge clk) begin
    if (cnt == 3'b100) begin
        // Transfer the shift register's contents to the parallel output
        dout_parallel <= shift_reg;
        dout_valid <= 1'b1;
    end else begin
        dout_valid <= 1'b0;
    end
end

endmodule