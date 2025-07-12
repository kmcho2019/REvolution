module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

// State encoding
localparam IDLE      = 2'd0;
localparam LOAD_DELAY= 2'd1;
localparam COUNTING  = 2'd2;
localparam DONE      = 2'd3;

reg [1:0] state, next_state;

// Shift register to detect pattern 1101 in IDLE
reg [3:0] shift_reg;

// Register to hold the delay value loaded in LOAD_DELAY
reg [3:0] delay;

// Counter for counting 1000 clock cycles (10 bits for 0 to 999)
reg [9:0] cycle_count;

// Delay block counter: counts down from delay to 0 in 1 step per 1000 cycles
reg [3:0] block_count;

// Counter load flag
wire cycle_count_max = (cycle_count == 10'd999);

// Sequential logic for state transitions and registers
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_reg <= 4'd0;
        delay <= 4'd0;
        cycle_count <= 10'd0;
        block_count <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
        count <= 4'd0;
    end else begin
        state <= next_state;

        case(state)
        IDLE: begin
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
            // Shift in the data bit to detect pattern
            shift_reg <= {shift_reg[2:0], data};
        end

        LOAD_DELAY: begin
            // Shift in delay bits MSB first: shift_reg is used as a counter of how many delay bits shifted?
            // Use a separate reg to count delay bits loaded, but here we will shift delay reg left and bring in data at LSB since problem states MSB first
            
            // shift delay to left and insert data at LSB to build delay MSB first
            delay <= {delay[2:0], data};
        end

        COUNTING: begin
            counting <= 1'b1;
            done <= 1'b0;

            if (cycle_count_max) begin
                cycle_count <= 10'd0;
                // Decrement block_count if not zero
                if (block_count != 4'd0)
                    block_count <= block_count - 4'd1;
            end else begin
                cycle_count <= cycle_count + 10'd1;
            end

            count <= block_count;
        end

        DONE: begin
            counting <= 1'b0;
            done <= 1'b1;
            count <= 4'd0;
        end

        default: begin
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end
        endcase
    end
end

// Counters and FSM next state logic

// To count how many bits of delay loaded in LOAD_DELAY state
reg [2:0] delay_bits_loaded;

always @(posedge clk) begin
    if (reset) begin
        delay_bits_loaded <= 3'd0;
    end else if (state == LOAD_DELAY) begin
        delay_bits_loaded <= delay_bits_loaded + 3'd1;
    end else begin
        delay_bits_loaded <= 3'd0;
    end
end

// Pattern detection combinational
wire pattern_detected = (shift_reg == 4'b1101);

always @(*) begin
    next_state = state;
    case(state)
    IDLE: begin
        if (pattern_detected)
            next_state = LOAD_DELAY;
    end

    LOAD_DELAY: begin
        if (delay_bits_loaded == 3'd4)  // loaded 4 bits
            next_state = COUNTING;
    end

    COUNTING: begin
        // When block_count reaches 0 and last 1000 cycles finish, go to DONE
        if ((block_count == 4'd0) && cycle_count_max)
            next_state = DONE;
    end

    DONE: begin
        if (ack)
            next_state = IDLE;
    end

    default: next_state = IDLE;
    endcase
end

// Initialize variables at LOAD_DELAY state start
reg load_delay_start;

always @(posedge clk) begin
    if (reset) begin
        load_delay_start <= 1'b0;
    end else begin
        // load_delay_start pulse when entering LOAD_DELAY
        load_delay_start <= (state == IDLE && next_state == LOAD_DELAY);
    end
end

always @(posedge clk) begin
    if (load_delay_start) begin
        delay <= 4'd0;
    end
end

// Initialize counting variables at COUNTING state start
reg counting_start;

always @(posedge clk) begin
    if (reset) begin
        block_count <= 4'd0;
        cycle_count <= 10'd0;
    end else begin
        // pulse when entering COUNTING state
        counting_start <= (state == LOAD_DELAY && next_state == COUNTING);

        if (counting_start) begin
            // block_count starts at delay
            block_count <= delay;
            cycle_count <= 10'd0;
        end
    end
end

endmodule