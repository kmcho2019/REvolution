module serial2parallel (
    input            clk,
    input            rst_n,
    input            din_serial,
    input            din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] bit_count;

    // Shift register: shifts left, MSB receives new serial input
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
        end else if (din_valid) begin
            shift_reg <= {shift_reg[6:0], din_serial};
        end
    end

    // Counter for number of received bits
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

    // Output registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default de-assert
            if (din_valid && (bit_count == 4'd7)) begin
                dout_parallel <= {shift_reg[6:0], din_serial};
                dout_valid    <= 1'b1;
            end
        end
    end

endmodule