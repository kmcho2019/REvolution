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
    localparam COUNTING = 2'b01;
    localparam DONE     = 2'b10;

    reg [1:0] state;
    reg [3:0] delay_val;
    reg [13:0] cycle_counter; // Enough for 15*1000 = 15000 cycles
    reg [3:0] pattern_reg;

    // Pattern detection (shift register)
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
        end else if (state == IDLE) begin
            pattern_reg <= {pattern_reg[2:0], data};
        end
    end

    // Pattern match signal
    wire pattern_match = (pattern_reg == 4'b1101);

    // Main state machine
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            delay_val <= 4'b0;
            cycle_counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (pattern_match) begin
                        // Start capturing delay value
                        delay_val <= {delay_val[2:0], data};
                        state <= COUNTING;
                        cycle_counter <= 0;
                    end
                end

                COUNTING: begin
                    if (cycle_counter < (delay_val + 1) * 1000 - 1) begin
                        cycle_counter <= cycle_counter + 1;
                    end else begin
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

    // Output logic
    assign counting = (state == COUNTING);
    assign done = (state == DONE);
    
    // Calculate remaining time (count output)
    wire [13:0] remaining_cycles = (delay_val + 1) * 1000 - 1 - cycle_counter;
    assign count = (state == COUNTING) ? remaining_cycles / 1000 : 4'b0;

endmodule