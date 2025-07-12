module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States
    localparam SEARCH     = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNT      = 2'd2;
    localparam DONE       = 2'd3;

    reg [1:0] state, next_state;

    reg [3:0] pattern_shift;
    reg [3:0] delay_reg;
    reg [2:0] load_bits;         // count bits loaded for delay (0 to 4)
    reg [9:0] micro_counter;     // counts 0..999 cycles
    reg [4:0] step_counter;      // counts remaining steps (delay+1 down to 0)

    // State register and outputs
    always @(posedge clk) begin
        if (reset) begin
            state         <= SEARCH;
            pattern_shift <= 4'b0;
            delay_reg     <= 4'b0;
            load_bits     <= 3'd0;
            micro_counter <= 10'd0;
            step_counter  <= 5'd0;
            counting      <= 1'b0;
            done          <= 1'b0;
            count         <= 4'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift in data to pattern_shift
                    pattern_shift <= {pattern_shift[2:0], data};
                    load_bits     <= 3'd0;
                    counting      <= 1'b0;
                    done          <= 1'b0;
                    count         <= 4'b0;
                    micro_counter <= 10'd0;
                    step_counter  <= 5'd0;
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first
                    delay_reg <= {delay_reg[2:0], data};
                    load_bits <= load_bits + 1'b1;
                    pattern_shift <= pattern_shift; // hold
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    micro_counter <= 10'd0;
                    step_counter <= 5'd0;
                end

                COUNT: begin
                    // Hold pattern and delay registers
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    load_bits <= load_bits;

                    counting <= 1'b1;
                    done <= 1'b0;

                    // Counting logic:
                    if (micro_counter == 10'd999) begin
                        micro_counter <= 10'd0;
                        if (step_counter != 0)
                            step_counter <= step_counter - 1'b1;
                    end else begin
                        micro_counter <= micro_counter + 1'b1;
                    end

                    // Output count stable during 1000 cycles: count = step_counter - 1 when micro_counter == 999 else step_counter
                    // But step_counter counts down from delay+1 to 0, output should be from delay down to 0
                    if (step_counter != 0) begin
                        if (micro_counter == 10'd999)
                            count <= (step_counter - 1'b1)[3:0];
                        else
                            count <= step_counter[3:0];
                    end else begin
                        count <= 4'd0;
                    end
                end

                DONE: begin
                    // Hold all registers stable
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    load_bits <= 3'd0;
                    micro_counter <= 10'd0;
                    step_counter <= 5'd0;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0; // don't-care
                end

                default: begin
                    // Fallback to SEARCH
                    state         <= SEARCH;
                    pattern_shift <= 4'b0;
                    delay_reg     <= 4'b0;
                    load_bits     <= 3'd0;
                    micro_counter <= 10'd0;
                    step_counter  <= 5'd0;
                    counting      <= 1'b0;
                    done          <= 1'b0;
                    count         <= 4'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: 
                if (pattern_shift == 4'b1101) next_state = LOAD_DELAY;
                else next_state = SEARCH;

            LOAD_DELAY: 
                if (load_bits == 3'd4) next_state = COUNT;
                else next_state = LOAD_DELAY;

            COUNT:
                // Transition to DONE after counting completes
                if ((step_counter == 0) && (micro_counter == 10'd999))
                    next_state = DONE;
                else
                    next_state = COUNT;

            DONE:
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = DONE;

            default:
                next_state = SEARCH;
        endcase
    end

    // Load step_counter = delay + 1 on entering COUNT state
    // Detect rising edge of COUNT state
    reg count_state_d;
    always @(posedge clk) begin
        if (reset) begin
            count_state_d <= 1'b0;
            step_counter <= 5'd0;
            micro_counter <= 10'd0;
        end else begin
            count_state_d <= (state == COUNT);
            if (~count_state_d && (state == COUNT)) begin
                step_counter <= delay_reg + 1'b1;
                micro_counter <= 10'd0;
            end
        end
    end

endmodule