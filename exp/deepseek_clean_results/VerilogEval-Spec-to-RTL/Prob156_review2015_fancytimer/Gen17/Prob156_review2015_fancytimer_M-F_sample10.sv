module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output counting,
    output done,
    input ack
);

    // State encoding
    localparam [1:0]
        IDLE    = 2'b00,
        CAPTURE = 2'b01,
        COUNT   = 2'b10,
        DONE    = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern;
    reg [3:0] delay;
    reg [2:0] bit_cnt;
    reg [13:0] cycle_cnt;
    reg [9:0] interval_cnt;  // Counts 0-999 for each interval
    wire [13:0] total_cycles = (delay + 1) * 1000;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 4'b0;
            delay <= 4'b0;
            bit_cnt <= 3'b0;
            cycle_cnt <= 14'b0;
            interval_cnt <= 10'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        state <= CAPTURE;
                        bit_cnt <= 3'b0;
                    end
                end

                CAPTURE: begin
                    delay <= {delay[2:0], data};
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 3) begin
                        state <= COUNT;
                        cycle_cnt <= total_cycles;
                        interval_cnt <= 10'd999;
                        count <= delay;
                    end
                end

                COUNT: begin
                    cycle_cnt <= cycle_cnt - 1;
                    interval_cnt <= interval_cnt - 1;
                    
                    // Update interval count when current interval completes
                    if (interval_cnt == 0) begin
                        interval_cnt <= 10'd999;
                        count <= count - 1;
                    end
                    
                    if (cycle_cnt == 1) begin
                        state <= DONE;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        pattern <= 4'b0;  // Clear pattern for fresh detection
                    end
                end
            endcase
        end
    end

    assign counting = (state == COUNT);
    assign done = (state == DONE);

endmodule