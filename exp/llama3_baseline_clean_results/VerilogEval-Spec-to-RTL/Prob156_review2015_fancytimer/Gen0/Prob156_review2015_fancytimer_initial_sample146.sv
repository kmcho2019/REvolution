module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

reg [3:0] state; // 0: searching, 1: reading delay, 2: counting, 3: waiting
reg [3:0] delay; // stores the delay value
reg [11:0] timer; // counter for 1000 cycles
reg [3:0] remaining; // remaining count
reg [3:0] pattern_detected; // shift register for pattern detection

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // reset to searching state
        count <= 4'bxxxx; // don't care
        counting <= 0;
        done <= 0;
        pattern_detected <= 0;
    end
    else begin
        case (state)
            0: begin // searching for pattern
                if (data) begin
                    pattern_detected <= {pattern_detected[2:0], 1'b1};
                end
                else begin
                    pattern_detected <= {pattern_detected[2:0], 1'b0};
                end
                if (pattern_detected == 4'b1101) begin
                    state <= 1; // move to reading delay state
                end
            end
            1: begin // reading delay
                delay <= {delay[2:0], data}; // shift in delay bits
                if (delay[3] != 1'bx) begin
                    state <= 2; // move to counting state
                    timer <= 12'd0;
                    remaining <= delay;
                    counting <= 1;
                end
            end
            2: begin // counting
                if (timer < 12'd999) begin
                    timer <= timer + 1;
                end
                else begin
                    timer <= 0;
                    if (remaining > 0) begin
                        remaining <= remaining - 1;
                    end
                    else begin
                        state <= 3; // move to waiting state
                        counting <= 0;
                        done <= 1;
                    end
                end
                count <= remaining;
            end
            3: begin // waiting for acknowledgment
                if (ack) begin
                    state <= 0; // reset to searching state
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule