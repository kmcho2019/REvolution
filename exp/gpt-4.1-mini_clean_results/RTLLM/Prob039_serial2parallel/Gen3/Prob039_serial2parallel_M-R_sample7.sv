module serial2parallel (
    input         clk,
    input         rst_n,
    input         din_serial,
    input         din_valid,
    output reg [7:0] dout_parallel,
    output reg      dout_valid
);

    reg [3:0] cnt;            // 4-bit counter (0 to 7)
    reg [7:0] shift_reg;      // shift register for serial data
    reg       data_ready;     // flag to indicate 8-bit data ready

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt           <= 4'd0;
            shift_reg     <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
            data_ready    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default

            if (din_valid) begin
                // Shift the serial input bit into the LSB, shifting existing bits left
                shift_reg <= {shift_reg[6:0], din_serial};
                
                if (cnt == 4'd7) begin
                    // Received 8 bits, output parallel data next cycle
                    data_ready <= 1'b1;
                    cnt <= 4'd0;
                end else begin
                    cnt <= cnt + 1;
                    data_ready <= 1'b0;
                end
            end else begin
                data_ready <= 1'b0;
            end

            if (data_ready) begin
                dout_parallel <= shift_reg;
                dout_valid <= 1'b1;
            end
        end
    end

endmodule