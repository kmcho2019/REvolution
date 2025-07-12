module serial2parallel (
    input         clk,
    input         rst_n,
    input         din_serial,
    input         din_valid,
    output reg [7:0] dout_parallel,
    output reg    dout_valid
);

    reg [7:0] shift_reg;
    reg [2:0] cnt;

    // Function to reverse bits in a byte
    function [7:0] reverse_bits;
        input [7:0] in;
        integer i;
        begin
            for (i = 0; i < 8; i = i + 1) begin
                reverse_bits[i] = in[7 - i];
            end
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg    <= 8'd0;
            cnt          <= 3'd0;
            dout_parallel <= 8'd0;
            dout_valid   <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // Default: deassert valid

            if (din_valid) begin
                shift_reg <= {shift_reg[6:0], din_serial};  // Shift left, input bit into LSB
                if (cnt == 3'd7) begin
                    dout_parallel <= reverse_bits({shift_reg[6:0], din_serial}); // Reverse bits for MSB-first output
                    dout_valid <= 1'b1;
                    cnt <= 3'd0;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

endmodule