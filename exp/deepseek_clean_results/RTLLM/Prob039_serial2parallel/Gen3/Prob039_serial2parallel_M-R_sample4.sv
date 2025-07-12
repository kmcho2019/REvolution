module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output wire [7:0] dout_parallel,
    output reg dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] bit_cnt;  // Counts 0-8 (needs 4 bits)

    // Shift register implementation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
            bit_cnt <= 4'b0;
        end
        else if (din_valid) begin
            shift_reg <= {shift_reg[6:0], din_serial};  // Shift left
            bit_cnt <= (bit_cnt == 4'd7) ? 4'd0 : (bit_cnt + 4'd1);
        end
    end

    // Output validity (registered)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= (din_valid && (bit_cnt == 4'd7));
        end
    end

    // Continuous output assignment
    assign dout_parallel = shift_reg;

endmodule