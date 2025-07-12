module serial2parallel (
    input           clk,
    input           rst_n,
    input           din_serial,
    input           din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] cnt;

    // Function to reverse 8 bits: bit 0 <-> bit 7, bit 1 <-> bit 6, ...
    function [7:0] bit_reverse;
        input [7:0] data_in;
        integer i;
        begin
            for (i = 0; i < 8; i = i + 1)
                bit_reverse[i] = data_in[7 - i];
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg     <= 8'b0;
            cnt           <= 4'b0;
            dout_parallel <= 8'b0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // Default output valid low each cycle

            if (din_valid) begin
                // Shift left by one bit, input bit enters at LSB
                shift_reg <= {shift_reg[6:0], din_serial};

                if (cnt == 4'd7) begin
                    // When 8 bits are collected, reverse bits to map first bit to MSB
                    dout_parallel <= bit_reverse({shift_reg[6:0], din_serial});
                    dout_valid    <= 1'b1;
                    cnt           <= 4'b0;
                    shift_reg     <= 8'b0;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

endmodule