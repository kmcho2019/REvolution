module serial2parallel (
    input           clk,
    input           rst_n,
    input           din_serial,
    input           din_valid,
    output reg [7:0] dout_parallel,
    output reg      dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] cnt; // 4-bit counter, count valid bits

    always @(posedge clk) begin
        if (!rst_n) begin
            shift_reg     <= 8'd0;
            cnt           <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default no output valid

            if (din_valid) begin
                // Shift in new bit at MSB, shifting right to place oldest bit in MSB
                shift_reg <= {din_serial, shift_reg[7:1]};
                if (cnt == 4'd7) begin
                    // On 8th bit (count from 0 to 7), output and reset counter
                    dout_parallel <= {din_serial, shift_reg[7:1]};
                    dout_valid <= 1'b1;
                    cnt <= 4'd0;
                end else begin
                    cnt <= cnt + 4'd1;
                end
            end
        end
    end

endmodule