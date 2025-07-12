module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // State encoding
    localparam [1:0]
        S_IDLE      = 2'b00,
        S_COUNTING  = 2'b01,
        S_DONE      = 2'b10;

    reg [1:0] state, next_state;

    // Shift register and pattern detection
    reg [3:0] shift_reg;
    wire pattern_match = (shift_reg == 4'b1101);

    // Delay capture
    reg [3:0] delay_value;
    reg [2:0] bit_count;

    // Cycle counting
    reg [13:0] cycle_counter;  // Enough for (15+1)*1000 = 16000 cycles
    wire [13:0] total_cycles = {delay_value, 10'b0} + 14'd1000; // (delay+1)*1000

    // Output calculation
    wire [3:0] remaining_phases = (cycle_counter / 14'd1000) - 1'b1;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            shift_reg <= 4'b0;
            delay_value <= 4'b0;
            bit_count <= 3'b0;
            cycle_counter <= 14'b0;
            
            // Outputs
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            shift_reg <= {shift_reg[2:0], data};

            case (state)
                S_IDLE: begin
                    if (pattern_match) begin
                        bit_count <= 3'b0;
                    end else if (bit_count < 3'd4) begin
                        delay_value <= {delay_value[2:0], data};
                        bit_count <= bit_count + 1;
                    end
                end

                S_COUNTING: begin
                    if (cycle_counter > 0) begin
                        cycle_counter <= cycle_counter - 1;
                    end
                end

                S_DONE: begin
                    if (ack) begin
                        shift_reg <= 4'b0;
                    end
                end
            endcase

            // Output updates
            counting <= (state == S_COUNTING);
            done <= (state == S_DONE);
            count <= (state == S_COUNTING) ? remaining_phases : 4'b0;
        end
    end

    always @(*) begin
        case (state)
            S_IDLE: begin
                if (pattern_match && bit_count == 3'd4) begin
                    next_state = S_COUNTING;
                end else begin
                    next_state = S_IDLE;
                end
            end

            S_COUNTING: begin
                next_state = (cycle_counter == 0) ? S_DONE : S_COUNTING;
            end

            S_DONE: begin
                next_state = ack ? S_IDLE : S_DONE;
            end

            default: next_state = S_IDLE;
        endcase
    end

    // Initialize cycle counter when entering counting state
    always @(posedge clk) begin
        if (state == S_IDLE && next_state == S_COUNTING) begin
            cycle_counter <= total_cycles - 1'b1; // Count down to 0
        end
    end

endmodule