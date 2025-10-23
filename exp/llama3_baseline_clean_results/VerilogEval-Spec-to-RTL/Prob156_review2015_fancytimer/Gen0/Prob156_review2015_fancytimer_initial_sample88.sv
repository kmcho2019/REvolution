module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] state;
reg [3:0] delay;
reg [3:0] counter;
reg [11:0] down_counter;

// Define states
parameter IDLE = 4'd0;
parameter PATTERN_DETECTED = 4'd1;
parameter COUNTING = 4'd2;
parameter DONE = 4'd3;

// Define pattern bits
reg [3:0] pattern_bits;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        delay <= 0;
        counter <= 0;
        down_counter <= 0;
        counting <= 0;
        done <= 0;
        pattern_bits <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    pattern_bits <= {pattern_bits[2:0], 1'b1};
                    if (pattern_bits == 4'd13) begin
                        state <= PATTERN_DETECTED;
                        pattern_bits <= 0;
                    end
                end else begin
                    pattern_bits <= {pattern_bits[2:0], 1'b0};
                    if (pattern_bits == 4'd5) begin
                        state <= PATTERN_DETECTED;
                        pattern_bits <= 0;
                    end
                end
            end
            PATTERN_DETECTED: begin
                if (counter == 4'd4) begin
                    state <= COUNTING;
                    down_counter <= (delay + 1) * 1000;
                end else begin
                    delay <= {delay[2:0], data};
                    counter <= counter + 1;
                end
            end
            COUNTING: begin
                if (down_counter == 12'd0) begin
                    state <= DONE;
                    done <= 1;
                end else begin
                    down_counter <= down_counter - 1;
                    if (down_counter[11:3] == 12'd0) begin
                        count <= delay;
                    end else begin
                        count <= delay - (12'd1000 - down_counter[11:3]);
                    end
                    counting <= 1;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    delay <= 0;
                    counter <= 0;
                    down_counter <= 0;
                    counting <= 0;
                    done <= 0;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule