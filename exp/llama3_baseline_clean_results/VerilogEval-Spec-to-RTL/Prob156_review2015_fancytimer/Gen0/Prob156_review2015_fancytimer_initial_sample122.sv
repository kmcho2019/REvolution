module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

reg [3:0] state; // 0: Idle, 1: Delay_Load, 2: Counting, 3: Done
reg [3:0] delay; // 4-bit delay value
reg [9:0] counter; // counter for clock cycles
reg [3:0] remaining; // remaining time
reg [3:0] pattern; // shift register for pattern detection
reg pattern_detected; // flag to indicate pattern detection

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Idle
        pattern_detected <= 0;
        pattern <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // Idle
                if (data == 1) begin // start shifting pattern
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        pattern_detected <= 1;
                        state <= 1; // Delay_Load
                    end else begin
                        pattern_detected <= 0;
                    end
                end else begin
                    pattern <= {pattern[2:0], data};
                end
            end
            1: begin // Delay_Load
                delay <= {delay[2:0], data}; // shift in delay value
                if (delay[0] == 1'b1) begin
                    state <= 2; // Counting
                    remaining <= delay + 1;
                    counter <= 0;
                    counting <= 1;
                end
            end
            2: begin // Counting
                counter <= counter + 1;
                if (counter == 1000) begin
                    remaining <= remaining - 1;
                    counter <= 0;
                    if (remaining == 0) begin
                        state <= 3; // Done
                        done <= 1;
                        counting <= 0;
                    end
                end
                count <= remaining - 1;
            end
            3: begin // Done
                if (ack == 1) begin
                    state <= 0; // Idle
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule