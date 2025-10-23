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
    localparam IDLE        = 2'b00;
    localparam DETECT      = 2'b01;
    localparam SHIFT_DELAY = 2'b10;
    localparam COUNT       = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [3:0] count_value;
    reg [15:0] main_counter; // Enough for max 16*1000=16000 cycles

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            count_value <= 4'b0;
            main_counter <= 16'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    pattern_reg <= 4'b0;
                    main_counter <= 16'b0;
                end

                DETECT: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                end

                SHIFT_DELAY: begin
                    if (main_counter < 3) begin
                        delay_reg <= {delay_reg[2:0], data};
                        main_counter <= main_counter + 1;
                    end else begin
                        count_value <= {delay_reg[2:0], data};
                        main_counter <= 16'b0;
                    end
                end

                COUNT: begin
                    if (main_counter == (delay_reg + 1) * 1000 - 1) begin
                        main_counter <= 16'b0;
                    end else begin
                        main_counter <= main_counter + 1;
                    end

                    // Update count_value every 1000 cycles
                    if (main_counter != 0 && main_counter % 1000 == 0) begin
                        count_value <= count_value - 1;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = DETECT;
            
            DETECT: begin
                if (pattern_reg == 4'b1101)
                    next_state = SHIFT_DELAY;
                else
                    next_state = DETECT;
            end

            SHIFT_DELAY: begin
                if (main_counter == 3)
                    next_state = COUNT;
                else
                    next_state = SHIFT_DELAY;
            end

            COUNT: begin
                if (main_counter == (delay_reg + 1) * 1000 - 1)
                    next_state = IDLE;
                else
                    next_state = COUNT;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic
    assign counting = (state == COUNT);
    assign done = (state == IDLE) && (pattern_reg == 4'b1101);
    assign count = (state == COUNT) ? count_value : 4'b0;

    // Handle ack
    always @(posedge clk) begin
        if (done && ack) begin
            state <= DETECT;
            pattern_reg <= 4'b0;
        end
    end

endmodule