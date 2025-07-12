module serial2parallel (
    input        clk,
    input        rst_n,
    input        din_serial,
    input        din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [3:0] cnt;
    reg [7:0] shift_reg;

    // Shift register update on valid data
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'd0;
        end else if (din_valid) begin
            // Shift left by one and insert new bit at LSB
            shift_reg <= {shift_reg[6:0], din_serial};
        end
    end

    // Counter update on valid data
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 4'd0;
        end else if (din_valid) begin
            if (cnt == 4'd7)
                cnt <= 4'd0;
            else
                cnt <= cnt + 1;
        end
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'd0;
            dout_valid <= 1'b0;
        end else begin
            // Assert dout_valid when 8 bits have been received (cnt == 7 and din_valid)
            if (din_valid && (cnt == 4'd7)) begin
                dout_parallel <= {shift_reg[6:0], din_serial};
                dout_valid <= 1'b1;
            end else begin
                dout_valid <= 1'b0;
            end
        end
    end

endmodule