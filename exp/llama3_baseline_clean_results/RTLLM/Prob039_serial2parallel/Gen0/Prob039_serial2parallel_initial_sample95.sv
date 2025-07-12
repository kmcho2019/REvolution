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

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        dout_parallel_reg <= 8'd0;
        dout_valid_reg <= 1'd0;
        cnt <= 4'd0;
    end else if (din_valid) begin
        // Shift serial data into parallel output
        if (cnt == 4'd0) begin
            dout_parallel_reg <= {din_serial, 7'd0};
        end else begin
            dout_parallel_reg <= {din_serial, dout_parallel_reg[7:1]};
        end

        // Increment counter
        cnt <= cnt + 1'd1;

        // Check if 8 bits have been received
        if (cnt == 4'd8) begin
            cnt <= 4'd0;  // Reset counter
            dout_valid_reg <= 1'd1;  // Set valid signal
        end else begin
            dout_valid_reg <= 1'd0;  // Reset valid signal
        end
    end else begin
        // If input data is not valid, do not update output
        cnt <= cnt;
        dout_valid_reg <= 1'd0;
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule