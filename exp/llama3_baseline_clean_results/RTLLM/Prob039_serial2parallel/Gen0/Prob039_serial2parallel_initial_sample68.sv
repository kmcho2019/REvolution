module serial2parallel (
    input            clk,
    input            rst_n,
    input            din_serial,
    input            din_valid,
    output reg [7:0] dout_parallel,
    output reg        dout_valid
);

reg [3:0] cnt;  // 4-bit counter
reg [7:0] parallel_reg;  // 8-bit register to store parallel output

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'd0;  // reset counter
        parallel_reg <= 8'd0;  // reset parallel register
        dout_valid <= 1'd0;  // reset dout_valid
    end else if (din_valid) begin
        // increment counter when valid serial input bit is received
        if (cnt < 4'd8) begin
            cnt <= cnt + 1;
        end
        
        // shift serial input bits into parallel output register
        if (cnt == 4'd1) begin
            parallel_reg <= {din_serial, 7'd0};  // load MSB
        end else if (cnt > 4'd1 && cnt < 4'd9) begin
            parallel_reg <= {parallel_reg[6:0], din_serial};  // shift in new bit
        end
        
        // output parallel data and set dout_valid when 8 bits have been received
        if (cnt == 4'd8) begin
            dout_parallel <= parallel_reg;
            dout_valid <= 1'd1;
        end else begin
            dout_valid <= 1'd0;
        end
    end
end

endmodule