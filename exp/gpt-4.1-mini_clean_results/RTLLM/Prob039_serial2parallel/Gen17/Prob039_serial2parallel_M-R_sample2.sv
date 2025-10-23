module serial2parallel (
    input           clk,
    input           rst_n,
    input           din_serial,
    input           din_valid,
    output reg [7:0] dout_parallel,
    output          dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] cnt;

    // dout_valid is high when cnt == 7 and din_valid is high, indicating 8th bit just arrived
    assign dout_valid = (cnt == 4'd7) && din_valid;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg     <= 8'b0;
            cnt           <= 4'b0;
            dout_parallel <= 8'b0;
        end else begin
            if (din_valid) begin
                // Shift left by one, insert new bit at LSB
                shift_reg <= {shift_reg[6:0], din_serial};
                if (cnt == 4'd7) begin
                    // 8 bits received, output data updated
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    cnt <= 4'b0;  // reset counter for next frame
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

endmodule