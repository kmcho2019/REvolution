module serial2parallel (
    input          clk,
    input          rst_n,
    input          din_serial,
    input          din_valid,
    output [7:0]   dout_parallel,
    output reg     dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] bit_count;
    reg       dout_valid_next;

    // Shift register: shift in MSB on each valid input
    always @(posedge clk) begin
        if (!rst_n) begin
            shift_reg <= 8'd0;
        end else if (din_valid) begin
            shift_reg <= {din_serial, shift_reg[7:1]};
        end
    end

    // Bit counter: count up when din_valid is asserted
    always @(posedge clk) begin
        if (!rst_n) begin
            bit_count <= 4'd0;
        end else if (din_valid) begin
            if (bit_count == 4'd7)
                bit_count <= 4'd0;
            else
                bit_count <= bit_count + 1'b1;
        end
    end

    // Generate dout_valid pulse when 8 bits are collected (bit_count == 7)
    always @(posedge clk) begin
        if (!rst_n) begin
            dout_valid <= 1'b0;
        end else begin
            // Assert dout_valid for 1 cycle immediately after last bit received
            dout_valid <= (din_valid && (bit_count == 4'd7));
        end
    end

    // Output parallel data directly from shift register
    assign dout_parallel = shift_reg;

endmodule