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
    localparam CAPTURE = 2'b01;
    localparam COUNTING = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [3:0] delay_value;
    reg [9:0] cycle_counter;
    reg [2:0] bit_counter;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            delay_value <= 4'b0;
            cycle_counter <= 10'b0;
            bit_counter <= 3'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    bit_counter <= bit_counter + 1;
                end
                
                CAPTURE: begin
                    delay_reg <= {delay_reg[2:0], data};
                    if (bit_counter == 3) begin
                        delay_value <= {delay_reg[2:0], data};
                        cycle_counter <= 0;
                    end
                    bit_counter <= bit_counter + 1;
                end
                
                COUNTING: begin
                    if (cycle_counter == 999) begin
                        cycle_counter <= 0;
                        if (delay_value != 0)
                            delay_value <= delay_value - 1;
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = (pattern_reg == 4'b1101 && bit_counter == 3) ? CAPTURE : IDLE;
            CAPTURE: next_state = (bit_counter == 3) ? COUNTING : CAPTURE;
            COUNTING: next_state = (delay_value == 0 && cycle_counter == 999) ? DONE : COUNTING;
            DONE: next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    assign counting = (state == COUNTING);
    assign done = (state == DONE);
    assign count = (state == COUNTING) ? delay_value : 4'b0;

endmodule