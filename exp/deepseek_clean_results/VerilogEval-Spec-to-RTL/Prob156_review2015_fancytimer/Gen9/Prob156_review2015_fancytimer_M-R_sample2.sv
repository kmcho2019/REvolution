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
    localparam IDLE        = 2'b00;
    localparam CAPTURE    = 2'b01;
    localparam COUNTING   = 2'b10;
    localparam DONE_STATE = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_val;
    reg [15:0] main_counter; // Handles up to 16*1000 = 16000 cycles
    reg [2:0] bit_counter;

    // Pattern detection (1101)
    wire pattern_match = (pattern_reg == 4'b1101);

    // Counter calculations
    wire [15:0] total_cycles = (delay_val + 1) * 1000;
    wire [3:0] remaining_periods = (main_counter / 1000);

    // Output assignments
    assign count = (state == COUNTING) ? remaining_periods : 4'b0;
    assign counting = (state == COUNTING);
    assign done = (state == DONE_STATE);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_val <= 4'b0;
            main_counter <= 16'b0;
            bit_counter <= 3'b0;
        end else begin
            // Continuous pattern detection
            pattern_reg <= {pattern_reg[2:0], data};

            case (state)
                IDLE: begin
                    if (pattern_match) begin
                        state <= CAPTURE;
                        bit_counter <= 3'b0;
                        delay_val <= 4'b0;
                    end
                end

                CAPTURE: begin
                    delay_val <= {delay_val[2:0], data};
                    bit_counter <= bit_counter + 1;
                    
                    if (bit_counter == 3'b11) begin
                        state <= COUNTING;
                        main_counter <= 16'b0;
                    end
                end

                COUNTING: begin
                    if (main_counter == total_cycles - 1) begin
                        state <= DONE_STATE;
                    end else begin
                        main_counter <= main_counter + 1;
                    end
                end

                DONE_STATE: begin
                    if (ack) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule