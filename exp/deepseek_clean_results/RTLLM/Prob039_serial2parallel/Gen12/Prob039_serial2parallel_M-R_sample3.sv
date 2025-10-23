module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    reg [2:0] bit_cnt;  // 3-bit counter (0-7)
    wire [7:0] shift_reg_next;
    reg [7:0] shift_reg;

    // Continuous assignment for shift register
    assign shift_reg_next = (din_valid) ? {shift_reg[6:0], din_serial} : shift_reg;

    // Valid signal generation
    assign dout_valid = (bit_cnt == 3'd7) && din_valid;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt <= 3'b0;
            shift_reg <= 8'b0;
            dout_parallel <= 8'b0;
        end
        else begin
            // Update shift register
            shift_reg <= shift_reg_next;

            // Update counter
            if (din_valid) begin
                bit_cnt <= (bit_cnt == 3'd7) ? 3'b0 : bit_cnt + 1'b1;
            end

            // Capture parallel output
            if (dout_valid) begin
                dout_parallel <= shift_reg_next;
            end
        end
    end

endmodule