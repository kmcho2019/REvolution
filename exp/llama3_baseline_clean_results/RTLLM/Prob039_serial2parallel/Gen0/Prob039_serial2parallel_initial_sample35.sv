module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt; // 4-bit counter
reg [7:0] dout_parallel_reg; // register for parallel output

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the module when reset signal is low
        cnt <= 4'd0;
        dout_valid <= 1'b0;
        dout_parallel_reg <= 8'd0;
    end else if (din_valid) begin
        // Shift the input bit into the register on each rising edge of the clock
        // when the input is valid
        if (cnt < 4'd8) begin
            dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
            cnt <= cnt + 1'b1;
            if (cnt == 4'd8) begin
                // Set the validity signal high when 8 input bits have been received
                dout_valid <= 1'b1;
            end else begin
                dout_valid <= 1'b0;
            end
        end else begin
            // Reset the counter and validity signal when 8 input bits have been received
            cnt <= 4'd0;
            dout_valid <= 1'b0;
        end
    end else begin
        // Do nothing when the input is not valid
        cnt <= cnt;
        dout_valid <= dout_valid;
        dout_parallel_reg <= dout_parallel_reg;
    end
end

// Continuous assignment for output
assign dout_parallel = dout_parallel_reg;

endmodule