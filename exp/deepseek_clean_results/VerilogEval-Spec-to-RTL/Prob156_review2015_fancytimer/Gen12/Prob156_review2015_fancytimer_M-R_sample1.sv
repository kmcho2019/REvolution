module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    // State encoding
    localparam IDLE    = 2'b00;
    localparam CAPTURE = 2'b01;
    localparam COUNT   = 2'b10;
    localparam DONE    = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [1:0] bit_counter;
    reg [9:0] cycle_counter;  // Counts 0-999
    reg [3:0] delay_value;
    reg [13:0] total_cycles;

    // State machine sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            bit_counter <= 2'b0;
            cycle_counter <= 10'b0;
            delay_value <= 4'b0;
            total_cycles <= 14'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        bit_counter <= 2'b0;
                        delay_reg <= 4'b0;
                    end
                end

                CAPTURE: begin
                    if (bit_counter < 3) begin
                        delay_reg <= {delay_reg[2:0], data};
                        bit_counter <= bit_counter + 1;
                    end else begin
                        delay_value <= {delay_reg[2:0], data};
                        total_cycles <= ({delay_reg[2:0], data} + 1) * 1000;
                        cycle_counter <= 10'b0;
                    end
                end

                COUNT: begin
                    if (cycle_counter == 999) begin
                        cycle_counter <= 10'b0;
                        total_cycles <= total_cycles - 1000;
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end

                DONE: begin
                    if (ack) begin
                        pattern_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

    // State machine combinational logic
    always @(*) begin
        case (state)
            IDLE: next_state = (pattern_reg == 4'b1101) ? CAPTURE : IDLE;
            CAPTURE: next_state = (bit_counter == 3) ? COUNT : CAPTURE;
            COUNT: next_state = (total_cycles <= 1000 && cycle_counter == 999) ? DONE : COUNT;
            DONE: next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    assign counting = (state == COUNT);
    assign done = (state == DONE);
    assign count = (state == COUNT) ? (total_cycles / 1000) : 4'b0;

endmodule