module serial2parallel (
    input           clk,
    input           rst_n,
    input           din_serial,
    input           din_valid,
    output reg [7:0] dout_parallel,
    output reg      dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] bit_count; // 4-bit counter per spec, counts 0 to 7

    // Shift register and counter update
    always @(posedge clk) begin
        if (!rst_n) begin
            shift_reg  <= 8'b0;
            bit_count  <= 4'd0;
        end else if (din_valid) begin
            // Shift left by 1, insert new bit at LSB
            shift_reg <= {shift_reg[6:0], din_serial};

            if (bit_count == 4'd7)
                bit_count <= 4'd0;   // wrap around after 8 bits
            else
                bit_count <= bit_count + 1'b1;
        end
    end

    // Output register and valid signal generation
    always @(posedge clk) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
            dout_valid    <= 1'b0;
        end else begin
            // By definition, dout_valid is high exactly on the cycle
            // after receiving the 8th bit (bit_count wrapping from 7 to 0)
            if (din_valid && (bit_count == 4'd7)) begin
                dout_parallel <= {shift_reg[6:0], din_serial};
                dout_valid    <= 1'b1;
            end else begin
                dout_valid <= 1'b0;
            end
        end
    end

endmodule