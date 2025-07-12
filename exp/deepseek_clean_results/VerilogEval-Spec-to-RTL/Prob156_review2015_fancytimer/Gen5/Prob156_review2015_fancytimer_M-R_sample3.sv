module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done
);

    // States
    localparam IDLE         = 3'b000;
    localparam GOT_PATTERN  = 3'b001;
    localparam CAPTURE_DELAY = 3'b010;
    localparam COUNTING     = 3'b011;
    localparam DONE         = 3'b100;

    reg [2:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [1:0] bit_counter;
    reg [15:0] cycle_counter;
    reg [15:0] cycles_total;
    reg [3:0] current_count;
    reg count_1000;

    // Continuous assignments
    assign count = (state == COUNTING) ? current_count : 4'b0;
    assign counting = (state == COUNTING);
    assign done = (state == DONE);

    // 1000-cycle counter
    always @(posedge clk) begin
        if (reset) begin
            count_1000 <= 0;
        end else if (state == COUNTING) begin
            count_1000 <= (cycle_counter % 1000 == 0) ? 1 : 0;
        end else begin
            count_1000 <= 0;
        end
    end

    // Main state machine
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            bit_counter <= 2'b0;
            cycle_counter <= 0;
            current_count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        state <= GOT_PATTERN;
                        bit_counter <= 0;
                    end
                end

                GOT_PATTERN: begin
                    state <= CAPTURE_DELAY;
                    delay_reg <= 4'b0;
                end

                CAPTURE_DELAY: begin
                    delay_reg <= {delay_reg[2:0], data};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 3) begin
                        cycles_total <= (delay_reg + 1) * 1000;
                        cycle_counter <= (delay_reg + 1) * 1000;
                        current_count <= delay_reg;
                        state <= COUNTING;
                    end
                end

                COUNTING: begin
                    cycle_counter <= cycle_counter - 1;
                    if (count_1000) begin
                        current_count <= current_count - 1;
                    end
                    if (cycle_counter == 1) begin
                        state <= DONE;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        pattern_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule