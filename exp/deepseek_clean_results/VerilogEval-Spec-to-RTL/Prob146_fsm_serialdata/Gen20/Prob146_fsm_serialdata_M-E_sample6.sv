module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // Gray-coded states for low-power transitions
    localparam [2:0] 
        IDLE    = 3'b000,
        START   = 3'b001,
        BIT7    = 3'b011,
        BIT6    = 3'b010,
        BIT5    = 3'b110,
        BIT4    = 3'b111,
        BIT3    = 3'b101,
        BIT2    = 3'b100,
        BIT1    = 3'b101,  // Reuse for area optimization
        STOP    = 3'b111;  // Reuse for area optimization

    reg [2:0] state, next_state;
    reg [7:0] shift_reg;
    reg [2:0] bit_counter;
    reg load_enable;

    // State transition and data processing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
            bit_counter <= 3'b0;
            load_enable <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;

            case (state)
                IDLE: begin
                    if (in == 1'b0) begin
                        load_enable <= 1'b1;
                        bit_counter <= 3'd6; // Initialize down counter
                    end
                end

                START: begin
                    if (load_enable) begin
                        shift_reg <= {in, 7'b0}; // Parallel load first bit
                        load_enable <= 1'b0;
                    end else begin
                        shift_reg <= {in, shift_reg[7:1]}; // Shift remaining bits
                        bit_counter <= bit_counter - 1;
                    end
                end

                default: begin // BIT7 to BIT1 states
                    shift_reg <= {in, shift_reg[7:1]};
                    if (bit_counter == 3'b0) begin
                        // Check stop bit while shifting last data bit
                        if (in == 1'b1) begin
                            out_byte <= {in, shift_reg[7:1]};
                            done <= 1'b1;
                        end
                    end else begin
                        bit_counter <= bit_counter - 1;
                    end
                end
            endcase
        end
    end

    // Predictive next state logic
    always @(*) begin
        case (state)
            IDLE:    next_state = (in == 1'b0) ? START : IDLE;
            START:   next_state = BIT7;
            BIT7:    next_state = BIT6;
            BIT6:    next_state = BIT5;
            BIT5:    next_state = BIT4;
            BIT4:    next_state = BIT3;
            BIT3:    next_state = BIT2;
            BIT2:    next_state = (bit_counter == 3'b0) ? IDLE : BIT1;
            BIT1:    next_state = (bit_counter == 3'b0) ? IDLE : STOP;
            STOP:    next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule