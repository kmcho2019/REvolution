module TopModule (
    input        clk,
    input        reset, // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg      counting,
    output reg      done,
    input           ack
);

    // FSM states
    typedef enum logic [1:0] {
        SEARCH    = 2'd0,
        LOAD      = 2'd1,
        COUNT     = 2'd2,
        WAIT_ACK  = 2'd3
    } state_t;

    state_t state, next_state;

    // Shift register holds last 5 bits shifted in (bit0 is newest)
    reg [4:0] shift_reg;

    // Delay register loaded in LOAD state MSB first
    reg [3:0] delay_reg;

    // Load bit counter (0..3)
    reg [2:0] load_bit_cnt;

    // Counters for counting state
    localparam CYCLES_PER_BLOCK = 1000;
    reg [9:0] cycle_counter; // counts 0..999 cycles
    reg [4:0] block_counter; // counts delay+1 down to 0

    // Pattern detected when bits [4:1] == 4'b1101
    wire pattern_detected = (shift_reg[4:1] == 4'b1101);

    // Next state logic combinational
    always_comb begin
        next_state = state;
        case(state)
            SEARCH: if (pattern_detected) next_state = LOAD;
            LOAD: if (load_bit_cnt == 3'd4) next_state = COUNT;
            COUNT: if ((block_counter == 0) && (cycle_counter == CYCLES_PER_BLOCK - 1)) next_state = WAIT_ACK;
            WAIT_ACK: if (ack) next_state = SEARCH;
        endcase
    end

    // Sequential logic
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_reg <= 5'b0;
            delay_reg <= 4'b0;
            load_bit_cnt <= 3'd0;
            cycle_counter <= 10'd0;
            block_counter <= 5'd0;
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift in new data bit at bit 0; shift_reg shifts left, MSB gets bit4, LSB gets data
                    // Newest bit at bit0 means shift right by 1 and insert data at bit4 would be incorrect.
                    // We want to shift left by 1, insert data at bit0:
                    shift_reg <= {shift_reg[3:0], data};

                    // Reset counters and flags
                    load_bit_cnt <= 3'd0;
                    delay_reg <= 4'b0;
                    cycle_counter <= 10'd0;
                    block_counter <= 5'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bx; // Don't care when not counting
                end

                LOAD: begin
                    // In LOAD, freeze shift_reg (no shifting)
                    shift_reg <= shift_reg;

                    // Shift in data bit MSB first into delay_reg
                    // We load 4 bits sequentially: delay_reg shifts left, new bit enters at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    load_bit_cnt <= load_bit_cnt + 1'b1;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bx; // don't care
                end

                COUNT: begin
                    // Freeze shift_reg and load_bit_cnt
                    shift_reg <= shift_reg;
                    load_bit_cnt <= load_bit_cnt;

                    counting <= 1'b1;
                    done <= 1'b0;

                    // Initialize counters at entry to COUNT state
                    if (state != COUNT && next_state == COUNT) begin
                        cycle_counter <= 10'd0;
                        block_counter <= delay_reg + 1'b1; // delay+1 blocks
                        count <= delay_reg;
                    end else begin
                        // Increment cycle counter each clock
                        if (cycle_counter == CYCLES_PER_BLOCK - 1) begin
                            cycle_counter <= 10'd0;
                            if (block_counter != 0)
                                block_counter <= block_counter - 1'b1;
                        end else begin
                            cycle_counter <= cycle_counter + 1'b1;
                        end

                        // Update count output
                        // count shows remaining blocks minus one or zero
                        if (block_counter == 0)
                            count <= 4'd0;
                        else
                            count <= block_counter - 1'b1;
                    end
                end

                WAIT_ACK: begin
                    // Freeze shift_reg and counters
                    shift_reg <= shift_reg;
                    load_bit_cnt <= load_bit_cnt;
                    delay_reg <= delay_reg;
                    cycle_counter <= cycle_counter;
                    block_counter <= block_counter;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bx; // don't care

                    // Reset handled by transition to SEARCH state on ack signal
                    if (ack) begin
                        // Reset pattern shift register and counters for new search
                        shift_reg <= 5'b0;
                        load_bit_cnt <= 3'd0;
                        delay_reg <= 4'b0;
                        cycle_counter <= 10'd0;
                        block_counter <= 5'd0;
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule