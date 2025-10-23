module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output counting,
    output done,
    input ack
);

    // State encoding
    typedef enum logic [1:0] {
        SEARCH     = 2'd0,
        READ_DELAY = 2'd1,
        COUNT      = 2'd2,
        DONE       = 2'd3
    } state_t;

    state_t state, next_state;

    reg [3:0] shift_reg;    // For pattern detection and reading delay bits (MSB first)
    reg [2:0] bits_read;    // Count bits read in READ_DELAY (0 to 3)
    reg [3:0] delay_reg;    // Stores the delay bits read

    reg [3:0] remaining;    // Counts down from delay to 0 during counting
    reg [9:0] cycle_count;  // Counts 0..999 clock cycles for each remaining tick

    // Outputs combinational
    assign counting = (state == COUNT);
    assign done = (state == DONE);

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_reg <= 4'd0;
            bits_read <= 3'd0;
            delay_reg <= 4'd0;
            remaining <= 4'd0;
            cycle_count <= 10'd0;
            count <= 4'd0;
        end else begin
            state <= next_state;
            case(state)
                SEARCH: begin
                    // Shift in data MSB first: shift_reg <= {shift_reg[2:0], data}
                    shift_reg <= {shift_reg[2:0], data};
                    bits_read <= 3'd0;
                    delay_reg <= 4'd0;
                    remaining <= 4'd0;
                    cycle_count <= 10'd0;
                    count <= 4'd0;
                end
                READ_DELAY: begin
                    // Shift delay bits MSB first
                    delay_reg <= {delay_reg[2:0], data};
                    bits_read <= bits_read + 1'b1;
                    count <= 4'd0;
                    cycle_count <= 10'd0;
                    remaining <= 4'd0;
                end
                COUNT: begin
                    count <= remaining;
                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'd0;
                        if (remaining != 4'd0)
                            remaining <= remaining - 1'b1;
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end
                end
                DONE: begin
                    count <= 4'd0;
                    cycle_count <= 10'd0;
                    remaining <= 4'd0;
                    bits_read <= 3'd0;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                // Pattern to detect: 1101
                // shift_reg MSB first, so shift_reg[3:0] matches bits as they come
                if (shift_reg == 4'b1101)
                    next_state = READ_DELAY;
            end
            READ_DELAY: begin
                if (bits_read == 3'd4)
                    next_state = COUNT;
            end
            COUNT: begin
                // Finish counting when remaining=0 and last cycle_count=999 done
                if ((remaining == 4'd0) && (cycle_count == 10'd999))
                    next_state = DONE;
            end
            DONE: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // On transition from READ_DELAY to COUNT, load remaining with delay_reg
    // Use a register to hold previous state to detect transition
    reg [1:0] prev_state;
    always @(posedge clk) begin
        if (reset)
            prev_state <= SEARCH;
        else
            prev_state <= state;
    end

    always @(posedge clk) begin
        if (reset) begin
            remaining <= 4'd0;
        end else if ((prev_state == READ_DELAY) && (state == COUNT)) begin
            remaining <= delay_reg;
        end
    end

endmodule