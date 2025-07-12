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

    // Function to reverse bits of an 8-bit vector
    function [7:0] reverse_bits;
        input [7:0] data_in;
        integer i;
        begin
            for (i = 0; i < 8; i = i + 1)
                reverse_bits[i] = data_in[7 - i];
        end
    endfunction

    always @(posedge clk) begin
        if (!rst_n) begin
            shift_reg     <= 8'd0;
            bit_count     <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default de-assert dout_valid each cycle

            if (din_valid) begin
                // Shift left by 1, insert din_serial at LSB
                shift_reg <= {shift_reg[6:0], din_serial};
                if (bit_count == 4'd7) begin
                    // Output reversed bits for MSB-first alignment
                    dout_parallel <= reverse_bits({shift_reg[6:0], din_serial});
                    dout_valid    <= 1'b1;
                    bit_count     <= 4'd0;
                end else begin
                    bit_count <= bit_count + 1;
                end
            end
        end
    end

endmodule