module serial2parallel (
    input           clk,
    input           rst_n,
    input           din_serial,
    input           din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg     <= 8'b0;
            cnt           <= 4'b0;
            dout_parallel <= 8'b0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // default low each cycle

            if (din_valid) begin
                // Shift right by one bit, input bit enters at MSB
                shift_reg <= {din_serial, shift_reg[7:1]};

                if (cnt == 4'd7) begin
                    // After 8 bits received, latch shift_reg to output and assert valid
                    dout_parallel <= {din_serial, shift_reg[7:1]};  // shift_reg updated above; this reflects new value
                    dout_valid    <= 1'b1;
                    cnt           <= 4'b0;
                    // shift_reg reset not strictly necessary here since new data will overwrite, but can be cleared if desired
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

endmodule