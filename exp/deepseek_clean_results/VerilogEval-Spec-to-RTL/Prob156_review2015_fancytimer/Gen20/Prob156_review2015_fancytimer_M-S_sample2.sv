module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States
    localparam IDLE  = 2'b00;
    localparam SHIFT = 2'b01;
    localparam COUNT = 2'b10;
    localparam DONE  = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern;
    reg [3:0] delay;
    reg [2:0] bit_cnt;    // Counts 0-3 for delay bits
    reg [15:0] timer;     // Main timer (handles up to 16*1000=16000 cycles)

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 4'b0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
            bit_cnt <= 0;
            timer <= 0;
        end else begin
            case (state)
                IDLE: begin
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        state <= SHIFT;
                        bit_cnt <= 0;
                        delay <= 4'b0;
                    end
                    counting <= 0;
                    done <= 0;
                end

                SHIFT: begin
                    delay <= {delay[2:0], data};
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 3) begin
                        state <= COUNT;
                        timer <= (delay + 1) * 1000 - 1;
                        count <= delay;
                        counting <= 1;
                    end
                end

                COUNT: begin
                    if (timer == 0) begin
                        state <= DONE;
                        counting <= 0;
                        done <= 1;
                    end else begin
                        timer <= timer - 1;
                        // Update count output every 1000 cycles
                        if (timer % 1000 == 0) count <= count - 1;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                        pattern <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule