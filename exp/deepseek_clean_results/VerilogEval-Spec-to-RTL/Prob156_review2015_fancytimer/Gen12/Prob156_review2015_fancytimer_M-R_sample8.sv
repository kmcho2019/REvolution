module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    // FSM states
    localparam IDLE     = 2'b00;
    localparam CAPTURE  = 2'b01;
    localparam COUNTING = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] delay_val;
    reg [3:0] periods_left;
    reg [9:0] cycle_counter;
    reg [1:0] bit_counter;
    reg [3:0] pattern_reg;

    // Continuous assignments
    assign counting = (state == COUNTING);
    assign done = (state == DONE);
    assign count = (state == COUNTING) ? periods_left : 4'b0;

    // Pattern detection (1101)
    wire pattern_match = (pattern_reg == 4'b1101);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_val <= 4'b0;
            periods_left <= 4'b0;
            cycle_counter <= 0;
            bit_counter <= 0;
        end else begin
            state <= next_state;
            pattern_reg <= {pattern_reg[2:0], data};
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = pattern_match ? CAPTURE : IDLE;
            CAPTURE: next_state = (bit_counter == 3) ? COUNTING : CAPTURE;
            COUNTING: next_state = (periods_left == 0 && cycle_counter == 999) ? DONE : COUNTING;
            DONE: next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Capture and counting logic
    always @(posedge clk) begin
        if (reset) begin
            delay_val <= 4'b0;
            periods_left <= 4'b0;
            cycle_counter <= 0;
            bit_counter <= 0;
        end else begin
            case (state)
                CAPTURE: begin
                    if (bit_counter < 3) begin
                        delay_val <= {delay_val[2:0], data};
                        bit_counter <= bit_counter + 1;
                    end else begin
                        periods_left <= {delay_val[2:0], data};
                        bit_counter <= 0;
                    end
                end
                
                COUNTING: begin
                    if (cycle_counter < 999) begin
                        cycle_counter <= cycle_counter + 1;
                    end else begin
                        cycle_counter <= 0;
                        if (periods_left > 0) begin
                            periods_left <= periods_left - 1;
                        end
                    end
                end
                
                default: begin
                    cycle_counter <= 0;
                    bit_counter <= 0;
                end
            endcase
        end
    end

endmodule