module serial2parallel (
    input          clk,
    input          rst_n,
    input          din_serial,
    input          din_valid,
    output reg [7:0] dout_parallel,
    output reg     dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] bit_count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg     <= 8'd0;
            bit_count     <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // Default no valid output

            if (din_valid) begin
                // Shift in new bit at MSB, older bits shift down
                shift_reg <= {din_serial, shift_reg[7:1]};

                if (bit_count == 4'd7) begin
                    // After 8 bits received, output parallel data and assert valid
                    dout_parallel <= {din_serial, shift_reg[7:1]}; // shift_reg not yet updated at this clock
                    dout_valid <= 1'b1;
                    bit_count <= 4'd0;
                end else begin
                    bit_count <= bit_count + 1'b1;
                end
            end
        end
    end

endmodule