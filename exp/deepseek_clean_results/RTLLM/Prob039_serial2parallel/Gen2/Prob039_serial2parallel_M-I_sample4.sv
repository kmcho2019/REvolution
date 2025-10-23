module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] cnt;
    reg [7:0] shift_reg;
    reg cnt_full;
    reg din_valid_reg;
    wire shift_enable;
    wire cnt_enable;

    // Clock gating control
    assign shift_enable = din_valid | (cnt != 3'b0);
    assign cnt_enable = din_valid;

    // Registered control signals
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            din_valid_reg <= 1'b0;
            cnt_full <= 1'b0;
        end else begin
            din_valid_reg <= din_valid;
            cnt_full <= (cnt == 3'd7);
        end
    end

    // Shift register with clock gating
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
        end else if (shift_enable) begin
            if (din_valid_reg) begin
                shift_reg <= {shift_reg[6:0], din_serial};
            end
        end
    end

    // Counter with enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'b0;
        end else if (cnt_enable) begin
            if (cnt_full) begin
                cnt <= 3'b0;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

    // Output registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end else begin
            dout_valid <= din_valid_reg & cnt_full;
            if (din_valid_reg & cnt_full) begin
                dout_parallel <= {shift_reg[6:0], din_serial};
            end
        end
    end

endmodule