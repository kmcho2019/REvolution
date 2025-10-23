module serial2parallel(
    input clk,        // Clock signal
    input rst_n,      // Reset signal (active low)
    input din_serial, // Serial input data
    input din_valid,  // Validity signal for input data
    output [7:0] dout_parallel, // Parallel output data (8 bits wide)
    output dout_valid // Validity signal for the output data
);

reg [3:0] cnt; // 4-bit counter
reg [7:0] dout_parallel_reg; // Register for parallel output data
reg dout_valid_reg; // Register for valid output signal

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'd0;
        dout_parallel_reg <= 8'd0;
        dout_valid_reg <= 1'b0;
    end else if (din_valid) begin
        if (cnt == 4'd7) begin
            dout_parallel_reg[7] <= din_serial;
            dout_valid_reg <= 1'b1;
            cnt <= 4'd0;
        end else begin
            dout_parallel_reg[7 - cnt] <= din_serial;
            dout_valid_reg <= 1'b0;
            cnt <= cnt + 1'b1;
        end
    end else begin
        dout_valid_reg <= 1'b0;
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule