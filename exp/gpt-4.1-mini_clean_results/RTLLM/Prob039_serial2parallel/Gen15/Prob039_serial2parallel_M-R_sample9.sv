module serial2parallel (
    input             clk,
    input             rst_n,
    input             din_serial,
    input             din_valid,
    output reg [7:0]  dout_parallel,
    output reg        dout_valid
);

    typedef enum logic [1:0] {
        IDLE    = 2'd0,
        COLLECT = 2'd1
    } state_t;

    state_t state, next_state;
    reg [7:0] shift_reg;
    reg [3:0] bit_count;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
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
                if (bit_count == 4'd8)
                    next_state = IDLE;
                else
                    next_state = COLLECT;
            end
            default: next_state = IDLE;
        endcase
    end

    // Shift register and bit counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'd0;
            bit_count <= 4'd0;
        end else begin
            case(state)
                IDLE: begin
                    if (din_valid) begin
                        // Start collecting: put first bit into MSB
                        shift_reg <= {din_serial, 7'd0};
                        bit_count <= 4'd1;
                    end else begin
                        shift_reg <= 8'd0;
                        bit_count <= 4'd0;
                    end
                end
                COLLECT: begin
                    if (din_valid && bit_count < 4'd8) begin
                        // Shift left by 1 and insert new bit at LSB
                        shift_reg <= {shift_reg[6:0], din_serial};
                        bit_count <= bit_count + 1'b1;
                    end
                end
                default: begin
                    shift_reg <= 8'd0;
                    bit_count <= 4'd0;
                end
            endcase
        end
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'd0;
            dout_valid <= 1'b0;
        end else begin
            // Default output
            dout_valid <= 1'b0;

            if (state == COLLECT && bit_count == 4'd8) begin
                dout_parallel <= shift_reg;
                dout_valid <= 1'b1;
            end
        end
    end

endmodule