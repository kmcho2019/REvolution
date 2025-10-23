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

    // Count valid bits received (0 to 7)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            bit_count <= 4'd0;
        else if (din_valid) begin
            if (bit_count == 4'd7)
                bit_count <= 4'd0;
            else
                bit_count <= bit_count + 1;
        end
    end

    // Shift register: shift in serial bits MSB-first on valid input
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shift_reg <= 8'd0;
        else if (din_valid)
            shift_reg <= {din_serial, shift_reg[7:1]};
    end

    // Output and valid signal generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'd0;
            dout_valid <= 1'b0;
        end else if (din_valid && (bit_count == 4'd7)) begin
            dout_parallel <= {din_serial, shift_reg[7:1]};
            dout_valid <= 1'b1;
        end else begin
            dout_valid <= 1'b0;
        end
    end

endmodule