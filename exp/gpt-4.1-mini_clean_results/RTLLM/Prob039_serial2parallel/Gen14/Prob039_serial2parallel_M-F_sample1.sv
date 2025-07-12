module serial2parallel (
    input             clk,
    input             rst_n,
    input             din_serial,
    input             din_valid,
    output reg [7:0]  dout_parallel,
    output reg        dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] cnt;           // 4-bit counter counts 0 to 7
    reg       data_ready;    // flag to indicate 8 bits received, output next cycle

    always @(posedge clk) begin
        if (!rst_n) begin
            shift_reg     <= 8'd0;
            cnt           <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
            data_ready    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default no valid output each cycle

            if (din_valid) begin
                // Shift right by one, insert din_serial at MSB
                shift_reg <= {din_serial, shift_reg[7:1]};

                if (cnt == 4'd7) begin
                    // 8 bits have been shifted in after this input
                    cnt        <= 4'd0;
                    data_ready <= 1'b1; // signal to output data next cycle
                end else begin
                    cnt        <= cnt + 1'b1;
                    data_ready <= 1'b0;
                end
            end else begin
                // No new data, maintain data_ready at 0 to avoid multiple pulses
                data_ready <= 1'b0;
            end

            // Output registered data one cycle after 8 bits received
            if (data_ready) begin
                dout_parallel <= shift_reg;
                dout_valid    <= 1'b1;
            end
        end
    end

endmodule