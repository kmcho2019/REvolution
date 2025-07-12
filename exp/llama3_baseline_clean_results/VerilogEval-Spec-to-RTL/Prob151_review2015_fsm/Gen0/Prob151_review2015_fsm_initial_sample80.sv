module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [2:0] state; // Idle, PatternDetected, Shifting, WaitingCounters, Done, AckWait
reg [3:0] pattern; // bits received so far
reg [1:0] shift_count; // number of bits shifted

localparam IDLE = 3'b000;
localparam PATTERN_DETECTED = 3'b001;
localparam SHIFTING = 3'b010;
localparam WAITING_COUNTERS = 3'b011;
localparam DONE = 3'b100;
localparam ACK_WAIT = 3'b101;

always @ (posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
        shift_count <= 2'b00;
    end else begin
        case (state)
            IDLE: begin
                pattern <= {data, pattern[3:1]};
                if (pattern == 4'b1101) begin
                    state <= PATTERN_DETECTED;
                end
            end
            PATTERN_DETECTED: begin
                state <= SHIFTING;
            end
            SHIFTING: begin
                shift_ena <= 1'b1;
                if (shift_count == 2'b11) begin
                    state <= WAITING_COUNTERS;
                    shift_ena <= 1'b0;
                end else begin
                    shift_count <= shift_count + 1;
                end
            end
            WAITING_COUNTERS: begin
                counting <= 1'b1;
                if (done_counting) begin
                    state <= DONE;
                    counting <= 1'b0;
                end
            end
            DONE: begin
                done <= 1'b1;
                if (ack) begin
                    state <= ACK_WAIT;
                end
            end
            ACK_WAIT: begin
                state <= IDLE;
                done <= 1'b0;
            end
        endcase
    end
end

endmodule