module serial2parallel (
    input           clk,
    input           rst_n,
    input           din_serial,
    input           din_valid,
    output reg [7:0] dout_parallel,
    output reg      dout_valid
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        COLLECT = 2'b01
    } state_t;

    state_t state, next_state;
    reg [3:0] cnt;
    reg [7:0] shift_reg;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt <= 4'd0;
            shift_reg <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid <= 1'b0;
        end else begin
            state <= next_state;

            dout_valid <= 1'b0; // default no valid output

            case(state)
                IDLE: begin
                    if (din_valid) begin
                        // Start collecting first bit
                        shift_reg <= {din_serial, 7'b0};
                        cnt <= 4'd0;
                    end
                end

                COLLECT: begin
                    if (din_valid) begin
                        shift_reg <= {shift_reg[6:0], din_serial}; // shift left, new bit at LSB
                        if (cnt == 4'd7) begin
                            dout_parallel <= {shift_reg[6:0], din_serial};
                            dout_valid <= 1'b1;
                            cnt <= 4'd0;
                        end else begin
                            cnt <= cnt + 1'b1;
                        end
                    end
                end

                default: begin
                    // Should never happen, reset state safely
                    state <= IDLE;
                    cnt <= 4'd0;
                    shift_reg <= 8'd0;
                    dout_valid <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (din_valid)
                    next_state = COLLECT;
                else
                    next_state = IDLE;
            end

            COLLECT: begin
                if (din_valid && cnt == 4'd7)
                    next_state = IDLE;
                else
                    next_state = COLLECT;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule