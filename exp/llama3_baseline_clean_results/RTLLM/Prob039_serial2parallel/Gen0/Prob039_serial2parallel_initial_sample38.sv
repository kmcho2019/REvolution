module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output [7:0] dout_parallel,
    output dout_valid
);

reg [7:0] dout_parallel_reg;
reg dout_valid_reg;
reg [3:0] cnt;

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        dout_parallel_reg <= 8'b0;
        dout_valid_reg <= 1'b0;
        cnt <= 4'b0;
    end else if (din_valid) begin
        if (cnt < 4'd8) begin
            // Shift the current parallel output to the left and add the new serial input
            dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
            cnt <= cnt + 1'b1;
            dout_valid_reg <= 1'b0;
        end else begin
            // If 8 bits have been received, set the valid output signal
            dout_valid_reg <= 1'b1;
            cnt <= 4'b0; // Reset the counter for the next sequence
        end
    end else begin
        // If the input is not valid, do not update the counter or output
        // But if the previous sequence was complete, reset the valid signal
        if (cnt == 4'd8) begin
            dout_valid_reg <= 1'b0;
            cnt <= 4'b0;
        end
    end
end

endmodule