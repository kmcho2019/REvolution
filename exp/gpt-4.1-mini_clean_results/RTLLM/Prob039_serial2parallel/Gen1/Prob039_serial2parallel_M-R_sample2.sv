module serial2parallel (
    input           clk,
    input           rst_n,
    input           din_serial,
    input           din_valid,
    output reg [7:0] dout_parallel,
    output reg      dout_valid
);

    // FSM state encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        LOAD = 2'b01,
        VALID = 2'b10
    } state_t;

    state_t state, next_state;

    reg [2:0] cnt;          // 3-bit counter sufficient for 0 to 7
    reg [7:0] shift_reg;

    // State transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt <= 3'd0;
            shift_reg <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    dout_valid <= 1'b0;
                    cnt <= 3'd0;
                    if (din_valid) begin
                        // Shift first bit in MSB position
                        shift_reg <= {din_serial, 7'd0};
                        cnt <= 3'd1;
                    end
                end

                LOAD: begin
                    dout_valid <= 1'b0;
                    if (din_valid) begin
                        // Shift existing bits to right, input goes to MSB
                        shift_reg <= {din_serial, shift_reg[7:1]};
                        cnt <= cnt + 1;
                    end
                end

                VALID: begin
                    dout_parallel <= shift_reg;
                    dout_valid <= 1'b1;
                    cnt <= 3'd0; // Reset count for next word
                end

                default: begin
                    dout_valid <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = (din_valid) ? LOAD : IDLE;
            LOAD: next_state = (cnt == 3'd7 && din_valid) ? VALID : LOAD;
            VALID: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule