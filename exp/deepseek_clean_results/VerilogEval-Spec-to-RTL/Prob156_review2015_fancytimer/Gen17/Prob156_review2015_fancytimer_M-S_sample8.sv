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
    localparam IDLE = 2'b00;
    localparam LOAD_COUNT = 2'b01;
    localparam DONE_STATE = 2'b10;

    reg [1:0] state;
    reg [3:0] pattern;
    reg [3:0] delay;
    reg [13:0] counter;  // 14-bit counter for max 16000 cycles

    // Pattern detection
    wire pattern_match = (pattern == 4'b1101);

    // Output assignments
    assign count = (state == LOAD_COUNT) ? counter[13:10] : 4'b0;
    assign counting = (state == LOAD_COUNT);
    assign done = (state == DONE_STATE);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 4'b0;
            delay <= 4'b0;
            counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    pattern <= {pattern[2:0], data};
                    if (pattern_match) begin
                        state <= LOAD_COUNT;
                        counter <= 4000;  // 4 bits to load + 1000 base cycles
                    end
                end

                LOAD_COUNT: begin
                    if (counter > 1000) begin
                        // Loading phase (first 4 cycles)
                        delay <= {delay[2:0], data};
                        counter <= counter - 1;
                    end else if (counter > 0) begin
                        // Counting phase
                        counter <= counter - 1;
                    end else begin
                        // Counting complete
                        state <= DONE_STATE;
                    end
                end

                DONE_STATE: begin
                    if (ack) begin
                        state <= IDLE;
                        pattern <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule