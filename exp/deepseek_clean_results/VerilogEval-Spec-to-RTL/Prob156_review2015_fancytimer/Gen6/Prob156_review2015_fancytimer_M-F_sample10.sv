module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // FSM states
    localparam IDLE = 0;
    localparam PATTERN_MATCH = 1;
    localparam CAPTURE_DELAY = 2;
    localparam COUNTING = 3;
    localparam DONE = 4;

    reg [2:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [15:0] main_counter;
    reg [3:0] captured_delay;
    reg [2:0] bit_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            main_counter <= 16'b0;
            captured_delay <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
            bit_count <= 3'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'b0;
                    pattern_reg <= {pattern_reg[2:0], data};
                    
                    // Check for pattern only when all 4 bits are filled
                    if (&bit_count[1:0]) begin
                        if (pattern_reg == 4'b1101) begin
                            state <= PATTERN_MATCH;
                            bit_count <= 3'b0;
                        end
                    end
                    bit_count <= bit_count + 1;
                end

                PATTERN_MATCH: begin
                    // Prepare to capture delay bits
                    delay_reg <= 4'b0;
                    bit_count <= 3'b0;
                    state <= CAPTURE_DELAY;
                end

                CAPTURE_DELAY: begin
                    delay_reg <= {delay_reg[2:0], data};
                    bit_count <= bit_count + 1;
                    
                    if (bit_count == 3'b011) begin  // After 4 bits
                        captured_delay <= delay_reg;
                        main_counter <= (delay_reg + 1) * 16'd1000;
                        state <= COUNTING;
                        counting <= 1'b1;
                    end
                end

                COUNTING: begin
                    if (main_counter > 0) begin
                        main_counter <= main_counter - 1;
                        // Calculate remaining intervals
                        count <= (main_counter / 1000) - 1;
                    end else begin
                        counting <= 1'b0;
                        done <= 1'b1;
                        state <= DONE;
                    end
                end

                DONE: begin
                    count <= 4'b0;  // Don't-care when not counting
                    if (ack) begin
                        state <= IDLE;
                        pattern_reg <= 4'b0;
                        bit_count <= 3'b0;
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule