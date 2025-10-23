module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output wire [7:0] dout_parallel,
    output wire dout_valid
);

    reg [3:0] bit_cnt;  // 4-bit counter (counts 0-7)
    reg [7:0] shift_reg;

    // Output assignments
    assign dout_parallel = shift_reg;
    assign dout_valid = (bit_cnt == 4'd7) & din_valid;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt <= 4'b0;
            shift_reg <= 8'b0;
        end
        else begin
            if (din_valid) begin
                if (bit_cnt < 4'd7) begin
                    shift_reg <= {shift_reg[6:0], din_serial};
                    bit_cnt <= bit_cnt + 1'b1;
                end
                else begin
                    // On 8th valid input, shift last bit and reset counter
                    shift_reg <= {shift_reg[6:0], din_serial};
                    bit_cnt <= 4'b0;
                end
            end
        end
    end

endmodule