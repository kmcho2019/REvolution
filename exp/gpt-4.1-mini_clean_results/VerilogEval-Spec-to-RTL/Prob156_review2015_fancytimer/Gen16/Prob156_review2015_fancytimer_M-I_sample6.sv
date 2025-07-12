module TopModule (
    input         clk,
    input         reset,   // synchronous active high
    input         data,
    output reg [3:0] count,
    output reg    counting,
    output reg    done,
    input         ack
);

    // FSM States
    typedef enum logic [1:0] {
        SEARCH     = 2'd0,
        DELAY_LOAD = 2'd1,
        COUNT      = 2'd2,
        WAIT_ACK   = 2'd3
    } state_t;

    state_t state, next_state;

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay register - load 4 bits MSB first by shifting left and inserting data at LSB
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded;  // counts 0 to 4

    // 14-bit total_count counter for counting down cycles
    reg [13:0] total_count;

    // Synchronous sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            delay_bits_loaded <= 3'd0;
            total_count <= 14'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift in new bit (MSB first): shift left, insert at LSB
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_bits_loaded <= 3'd0;
                    delay_reg <= delay_reg;
                    total_count <= 14'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                DELAY_LOAD: begin
                    // Shift delay_reg left, insert data at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;
                    pattern_shift <= pattern_shift;
                    total_count <= 14'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;
                    if (total_count != 14'd0)
                        total_count <= total_count - 1'b1;
                    else
                        total_count <= 14'd0;

                    // Output count = total_count / 1000 = number of 1000-cycle blocks remaining
                    // total_count counts down from (delay+1)*1000 - 1 to 0
                    count <= total_count / 14'd1000; 
                end

                WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    total_count <= 14'd0;
                    count <= 4'd0;
                end

                default: begin
                    state <= SEARCH;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    total_count <= 14'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            endcase

            // Initialize total_count on transition DELAY_LOAD->COUNT
            if ((state == COUNT) && (next_state != COUNT) && (delay_bits_loaded == 3'd4)) begin
                // This condition cannot be reliably used in sequential logic because state just updated above.
                // Instead, detect DELAY_LOAD->COUNT in combinational and set total_count synchronously there.
            end
        end
    end

    // To handle total_count initialization precisely on DELAY_LOAD->COUNT transition,
    // we implement a small register to catch that transition:
    reg delay_load_done_sync;
    always @(posedge clk) begin
        if (reset) begin
            delay_load_done_sync <= 1'b0;
            total_count <= 14'd0;
        end else begin
            delay_load_done_sync <= (state == DELAY_LOAD) && (delay_bits_loaded == 3'd4);
            if (delay_load_done_sync && (state == COUNT)) begin
                // Initialize total_count: (delay_reg + 1)*1000 - 1
                total_count <= ((delay_reg + 4'd1) * 14'd1000) - 14'd1;
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                // Detect pattern 1101 MSB first
                if (pattern_shift == 4'b1101)
                    next_state = DELAY_LOAD;
                else
                    next_state = SEARCH;
            end

            DELAY_LOAD: begin
                if (delay_bits_loaded == 3'd4)
                    next_state = COUNT;
                else
                    next_state = DELAY_LOAD;
            end

            COUNT: begin
                // Done when total_count reaches zero
                if (total_count == 14'd0)
                    next_state = WAIT_ACK;
                else
                    next_state = COUNT;
            end

            WAIT_ACK: begin
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = WAIT_ACK;
            end

            default: next_state = SEARCH;
        endcase
    end

endmodule