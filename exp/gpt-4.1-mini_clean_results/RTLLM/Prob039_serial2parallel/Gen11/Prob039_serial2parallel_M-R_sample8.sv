module serial2parallel (
    input        clk,
    input        rst_n,
    input        din_serial,
    input        din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [7:0] shift_reg;   // collects bits serially, LSB first
    reg [3:0] cnt;         // counts bits received 0 to 7

    // Function to reverse bits to map first received bit to MSB of dout_parallel
    function [7:0] reverse_bits;
        input [7:0] data_in;
        integer i;
        begin
            for (i = 0; i < 8; i = i + 1) begin
                reverse_bits[i] = data_in[7 - i];
            end
        end
    endfunction

    always @(posedge clk) begin
        if (!rst_n) begin
            shift_reg     <= 8'd0;
            cnt           <= 4'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default no valid output each cycle

            if (din_valid) begin
                // Shift left: MSB shifted out, input new bit at LSB
                shift_reg <= {shift_reg[6:0], din_serial};
                if (cnt == 4'd7) begin
                    // 8 bits received: output reversed data (to map first bit to MSB)
                    dout_parallel <= reverse_bits({shift_reg[6:0], din_serial});
                    dout_valid    <= 1'b1;
                    cnt           <= 4'd0;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

endmodule