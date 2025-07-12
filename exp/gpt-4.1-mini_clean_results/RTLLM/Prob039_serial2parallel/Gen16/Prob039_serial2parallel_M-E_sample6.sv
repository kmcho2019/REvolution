module serial2parallel (
    input           clk,
    input           rst_n,
    input           din_serial,
    input           din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    reg [7:0] data_reg;
    reg [3:0] bit_pos; // will count down from 7 to 0

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg      <= 8'b0;
            bit_pos       <= 4'd7;
            dout_parallel <= 8'b0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default, clear valid

            if (din_valid) begin
                data_reg[bit_pos] <= din_serial;

                if (bit_pos == 4'd0) begin
                    // Last bit received, output parallel data and set valid
                    dout_parallel <= data_reg;
                    dout_valid <= 1'b1;
                    bit_pos <= 4'd7; // reset for next byte
                end else begin
                    bit_pos <= bit_pos - 1'b1;
                end
            end
        end
    end

endmodule