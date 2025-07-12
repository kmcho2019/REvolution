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
    localparam SEARCH      = 2'b00;
    localparam CAPTURE     = 2'b01;
    localparam COUNTING    = 2'b10;
    localparam WAIT_ACK    = 2'b11;

    reg [1:0] state;
    reg [3:0] delay;
    reg [3:0] pattern;
    reg [1:0] bit_count;
    reg [15:0] total_cycles;  // Enough for max delay (15+1)*1000=16000 cycles

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            delay <= 4'b0;
            pattern <= 4'b0;
            bit_count <= 2'b0;
            total_cycles <= 16'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                SEARCH: begin
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        state <= CAPTURE;
                        bit_count <= 2'b0;
                    end
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                CAPTURE: begin
                    delay <= {delay[2:0], data};
                    bit_count <= bit_count + 1;
                    if (bit_count == 2'b11) begin
                        state <= COUNTING;
                        counting <= 1'b1;
                        total_cycles <= 16'd0;
                    end
                end

                COUNTING: begin
                    if (total_cycles == (delay + 1) * 1000 - 1) begin
                        state <= WAIT_ACK;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end else begin
                        total_cycles <= total_cycles + 1;
                    end
                    // Calculate remaining time (count = delay - total_cycles/1000)
                    count <= delay - (total_cycles / 1000);
                end

                WAIT_ACK: begin
                    if (ack) begin
                        state <= SEARCH;
                        done <= 1'b0;
                        pattern <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule