module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    // State encoding
    localparam IDLE = 1'b0;
    localparam COLLECT = 1'b1;
    reg state, next_state;

    // Shift register and bit counter
    reg [7:0] shift_reg;
    reg [2:0] bit_cnt;

    // State transitions
    always @(*) begin
        case (state)
            IDLE: next_state = din_valid ? COLLECT : IDLE;
            COLLECT: next_state = (bit_cnt == 3'd7) ? IDLE : COLLECT;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            bit_cnt <= 3'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            state <= next_state;

            // Shift register and counter update
            if (state == COLLECT && din_valid) begin
                shift_reg <= {shift_reg[6:0], din_serial};
                bit_cnt <= bit_cnt + 1'b1;
            end
            else if (state == IDLE) begin
                bit_cnt <= 3'b0;
            end

            // Output update
            if (state == COLLECT && bit_cnt == 3'd7 && din_valid) begin
                dout_parallel <= {shift_reg[6:0], din_serial};
                dout_valid <= 1'b1;
            end
            else begin
                dout_valid <= 1'b0;
            end
        end
    end

endmodule