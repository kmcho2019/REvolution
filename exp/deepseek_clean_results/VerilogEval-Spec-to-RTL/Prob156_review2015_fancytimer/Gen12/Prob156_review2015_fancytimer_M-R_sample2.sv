module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    // States
    localparam IDLE    = 2'b00;
    localparam CAPTURE = 2'b01;
    localparam COUNT   = 2'b10;
    localparam DONE    = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [1:0] bit_counter;
    reg [13:0] timer;
    reg [3:0] initial_delay;

    // Continuous assignments
    assign counting = (state == COUNT);
    assign done = (state == DONE);
    assign count = (state == COUNT) ? initial_delay - (timer / 1000) : 4'b0;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            bit_counter <= 2'b0;
            timer <= 14'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        delay_reg <= 4'b0;
                        bit_counter <= 2'b0;
                    end
                end

                CAPTURE: begin
                    delay_reg <= {delay_reg[2:0], data};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 2'b11) begin
                        initial_delay <= {delay_reg[2:0], data};
                        timer <= ({delay_reg[2:0], data} + 1) * 1000;
                    end
                end

                COUNT: begin
                    if (timer > 0)
                        timer <= timer - 1;
                end

                DONE: begin
                    if (ack) begin
                        pattern_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = (pattern_reg == 4'b1101) ? CAPTURE : IDLE;
            CAPTURE: next_state = (bit_counter == 2'b11) ? COUNT : CAPTURE;
            COUNT: next_state = (timer == 0) ? DONE : COUNT;
            DONE: next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

endmodule