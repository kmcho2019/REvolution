module serial2parallel (
    input          clk,
    input          rst_n,
    input          din_serial,
    input          din_valid,
    output reg [7:0] dout_parallel,
    output         dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] cnt;  // counts from 0 to 7

    // Shift register and counter update
    always @(posedge clk) begin
        if (!rst_n) begin
            shift_reg     <= 8'd0;
            cnt           <= 4'd0;
            dout_parallel <= 8'd0;
        end else begin
            if (din_valid) begin
                // Shift left by 1, insert new bit at LSB
                shift_reg <= {shift_reg[6:0], din_serial};
                
                if (cnt == 4'd7) begin
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    cnt <= 4'd0;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

    // dout_valid pulse combinationally generated on the 8th bit reception
    assign dout_valid = (din_valid && (cnt == 4'd7));

endmodule