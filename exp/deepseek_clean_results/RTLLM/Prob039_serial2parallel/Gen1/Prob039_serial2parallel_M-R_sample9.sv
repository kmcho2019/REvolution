module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] cnt, cnt_next;
    reg [7:0] shift_reg, shift_reg_next;
    wire cnt_full;

    // Combinational logic
    assign cnt_full = (cnt == 3'd7);

    always @(*) begin
        // Default assignments
        cnt_next = cnt;
        shift_reg_next = shift_reg;
        dout_valid = 1'b0;
        dout_parallel = 8'b0;

        if (din_valid) begin
            // Shift in new bit
            shift_reg_next = {shift_reg[6:0], din_serial};

            if (cnt_full) begin
                // Output when full
                dout_parallel = {shift_reg[6:0], din_serial};
                dout_valid = 1'b1;
                cnt_next = 3'b0;
            end else begin
                cnt_next = cnt + 1'b1;
            end
        end
    end

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'b0;
            shift_reg <= 8'b0;
        end else begin
            cnt <= cnt_next;
            shift_reg <= shift_reg_next;
        end
    end

endmodule