module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [3:0] cnt;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt <= 4'd0;
            shift_reg <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default to 0 each cycle

            if (din_valid) begin
                shift_reg <= {shift_reg[6:0], din_serial};  // Shift left, new bit at LSB
                if (cnt == 4'd7) begin
                    // 8 bits received after this input
                    dout_parallel <= {shift_reg[6:0], din_serial}; // Current shifted data
                    dout_valid <= 1'b1;
                    cnt <= 4'd0;
                end else begin
                    cnt <= cnt + 1;
                end
            end
        end
    end

endmodule