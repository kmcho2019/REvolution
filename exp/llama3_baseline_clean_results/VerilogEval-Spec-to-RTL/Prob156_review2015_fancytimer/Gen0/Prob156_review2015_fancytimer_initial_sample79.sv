module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] state; // 0: idle, 1: pattern detection, 2: shifting delay bits, 3: counting, 4: done
reg [3:0] delay;
reg [3:0] counter;
reg [9:0] timer;
reg pattern_detected;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // idle
        pattern_detected <= 0;
        timer <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (data == 1) begin
                    pattern_detected <= 1;
                    state <= 1; // pattern detection
                end else begin
                    pattern_detected <= 0;
                end
            end
            1: begin // pattern detection
                if (data == 1) begin
                    if (pattern_detected == 1) begin
                        state <= 1; // pattern detection
                    end else begin
                        pattern_detected <= 1;
                        state <= 1; // pattern detection
                    end
                end else if (pattern_detected == 1) begin
                    state <= 1; // pattern detection
                    pattern_detected <= 0;
                end else begin
                    pattern_detected <= 0;
                    state <= 0; // idle
                end
                if (pattern_detected == 1 && data == 1) begin
                    state <= 2; // shifting delay bits
                end
            end
            2: begin // shifting delay bits
                delay[3] <= data;
                state <= 3; // counting
            end
            3: begin // counting
                if (timer == 0) begin
                    count <= delay;
                    timer <= 1000 - 1;
                    counting <= 1;
                end else if (timer == 999) begin
                    if (delay == 0) begin
                        state <= 4; // done
                    end else begin
                        delay <= delay - 1;
                        timer <= 1000 - 1;
                    end
                end else begin
                    timer <= timer - 1;
                end
            end
            4: begin // done
                if (ack == 1) begin
                    state <= 0; // idle
                    done <= 0;
                    counting <= 0;
                end else begin
                    done <= 1;
                end
            end
            default: state <= 0; // idle
        endcase
    end
end

endmodule