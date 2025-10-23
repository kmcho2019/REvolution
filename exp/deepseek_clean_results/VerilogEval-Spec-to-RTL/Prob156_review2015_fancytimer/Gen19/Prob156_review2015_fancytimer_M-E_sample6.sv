module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // One-hot state encoding
    localparam [3:0]
        S_IDLE      = 4'b0001,
        S_CAPTURE   = 4'b0010,
        S_COUNTING  = 4'b0100,
        S_DONE      = 4'b1000;

    reg [3:0] state, next_state;

    // Shift register for last 4 bits
    reg [3:0] shift_reg;
    wire pattern_match = (shift_reg == 4'b1101);

    // Delay value capture
    reg [3:0] delay_value;
    reg [2:0] bit_count;

    // Counting logic
    reg [9:0] micro_count;    // Counts 0-999
    reg [3:0] macro_count;    // Counts delay phases
    wire micro_done = (micro_count == 10'd999);
    wire macro_done = (macro_count == 4'b0);

    // Output registers
    always @(posedge clk) begin
        if (reset) begin
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                S_COUNTING: count <= macro_count;
                default: count <= 4'b0;
            endcase
            
            counting <= (state == S_COUNTING);
            done <= (state == S_DONE);
        end
    end

    // Main state machine
    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            shift_reg <= 4'b0;
            delay_value <= 4'b0;
            bit_count <= 3'b0;
            micro_count <= 10'b0;
            macro_count <= 4'b0;
        end else begin
            state <= next_state;
            
            // Always shift in new data
            shift_reg <= {shift_reg[2:0], data};

            case (state)
                S_IDLE: begin
                    if (pattern_match) begin
                        bit_count <= 3'b0;
                    end
                end

                S_CAPTURE: begin
                    if (bit_count < 3'd4) begin
                        delay_value <= {delay_value[2:0], data};
                        bit_count <= bit_count + 1;
                    end
                end

                S_COUNTING: begin
                    if (micro_done) begin
                        micro_count <= 10'b0;
                        macro_count <= macro_count - 1;
                    end else begin
                        micro_count <= micro_count + 1;
                    end
                end

                S_DONE: begin
                    if (ack) begin
                        shift_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            S_IDLE: 
                next_state = pattern_match ? S_CAPTURE : S_IDLE;
            
            S_CAPTURE:
                next_state = (bit_count == 3'd4) ? S_COUNTING : S_CAPTURE;
            
            S_COUNTING:
                next_state = (micro_done && macro_done) ? S_DONE : S_COUNTING;
            
            S_DONE:
                next_state = ack ? S_IDLE : S_DONE;
            
            default:
                next_state = S_IDLE;
        endcase
    end

    // Initialize counting values when entering COUNTING state
    always @(posedge clk) begin
        if (state == S_CAPTURE && next_state == S_COUNTING) begin
            micro_count <= 10'b0;
            macro_count <= delay_value;
        end
    end

endmodule