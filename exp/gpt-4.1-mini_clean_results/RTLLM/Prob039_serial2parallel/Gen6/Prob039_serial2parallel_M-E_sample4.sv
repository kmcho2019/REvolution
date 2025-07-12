module serial2parallel (
    input             clk,
    input             rst_n,
    input             din_serial,
    input             din_valid,
    output reg [7:0]  dout_parallel,
    output reg        dout_valid
);

    reg [3:0] bit_count;
    reg [7:0] shift_reg;

    // Function to reverse bits for MSB-first output
    function [7:0] reverse_bits;
        input [7:0] data_in;
        integer i;
        begin
            for (i = 0; i < 8; i = i + 1) begin
                reverse_bits[i] = data_in[7 - i];
            end
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_count <= 4'd0;
            shift_reg <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // default no valid output

            if (din_valid) begin
                shift_reg <= {shift_reg[6:0], din_serial};  // Shift left, new bit at LSB
                bit_count <= bit_count + 4'd1;

                if (bit_count == 4'd7) begin
                    dout_parallel <= reverse_bits({shift_reg[6:0], din_serial});
                    dout_valid <= 1'b1;
                    bit_count <= 4'd0;
                end
            end
        end
    end

endmodule