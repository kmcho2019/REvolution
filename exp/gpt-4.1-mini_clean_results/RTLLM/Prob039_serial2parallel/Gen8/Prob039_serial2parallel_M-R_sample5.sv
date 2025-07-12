module serial2parallel (
    input        clk,
    input        rst_n,
    input        din_serial,
    input        din_valid,
    output reg [7:0] dout_parallel,
    output        dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] bit_count;

    // Counter: counts number of received valid bits
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_count <= 4'd0;
        end else if (din_valid) begin
            if (bit_count == 4'd7)
                bit_count <= 4'd0;
            else
                bit_count <= bit_count + 1'b1;
        end
    end

    // Shift register update on valid input
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'd0;
            dout_parallel <= 8'd0;
        end else if (din_valid) begin
            shift_reg <= {shift_reg[6:0], din_serial};
            // When count reaches 7, output parallel data
            if (bit_count == 4'd7) begin
                dout_parallel <= {shift_reg[6:0], din_serial};
            end
        end
    end

    // dout_valid is high when 8 bits have been received (bit_count == 7)
    assign dout_valid = (din_valid && (bit_count == 4'd7));

endmodule