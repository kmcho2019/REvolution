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
    end else begin
        if (din_valid) begin // Increment counter and shift in new data when input is valid
            cnt <= cnt + 1;
            shift_reg <= {shift_reg[6:0], din_serial};
        end
        if (cnt == 3'd8) begin // Output data when 8 bits have been received
            dout_parallel <= shift_reg;
            dout_valid <= 1'd1;
            cnt <= 3'd0; // Reset counter for next set of data
        end else begin
            dout_valid <= 1'd0;
        end
    end
end

endmodule