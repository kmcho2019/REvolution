module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] bit_cnt;
    reg [7:0] data_reg;
    wire cnt_enable = din_valid;
    wire terminal_cnt = (bit_cnt == 3'd7) & din_valid;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt <= 3'b0;
            data_reg <= 8'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            // Default assignments
            dout_valid <= 1'b0;

            // Shift register and counter update
            if (cnt_enable) begin
                data_reg <= {data_reg[6:0], din_serial};
                bit_cnt <= terminal_cnt ? 3'b0 : bit_cnt + 1;
            end

            // Parallel output update
            if (terminal_cnt) begin
                dout_parallel <= {data_reg[6:0], din_serial};
                dout_valid <= 1'b1;
            end
        end
    end

endmodule