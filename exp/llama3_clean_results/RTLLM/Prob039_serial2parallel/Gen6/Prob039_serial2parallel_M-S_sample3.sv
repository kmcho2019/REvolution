module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [2:0] cnt; // Counter to track the number of serial input bits received
reg [7:0] shift_reg; // Shift register to store incoming serial data

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset the circuit when rst_n is low
        cnt <= 3'd0;
        shift_reg <= 8'd0;
        dout_parallel <= 8'd0;
        dout_valid <= 1'd0;
    end else if (din_valid) begin
        if (cnt == 3'd7) begin // When 8 bits have been received
            dout_parallel <= shift_reg;
            dout_valid <= 1'd1;
            cnt <= 3'd0; // Reset the counter
        end else begin
            cnt <= cnt + 1; // Increment the counter
            shift_reg <= {shift_reg[6:0], din_serial}; // Shift the serial input bits into the shift register
            dout_valid <= 1'd0; // Reset the output valid signal
        end
    end else begin
        cnt <= 3'd0; // Reset the counter if input data is not valid
        shift_reg <= 8'd0; // Reset the shift register
        dout_valid <= 1'd0; // Reset the output valid signal
    end
end

endmodule