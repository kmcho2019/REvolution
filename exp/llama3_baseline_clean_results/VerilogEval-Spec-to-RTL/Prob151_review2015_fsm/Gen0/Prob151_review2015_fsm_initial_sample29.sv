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

// State machine states
parameter IDLE = 4'd0;
parameter SHIFT = 4'd1;
parameter COUNTING = 4'd2;
parameter DONE = 4'd3;

reg [3:0] state;
reg [3:0] nextState;

reg [3:0] pattern Detector;
reg [1:0] shiftCounter;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        patternDetector <= 4'd0;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
        shiftCounter <= 2'd0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    patternDetector <= {patternDetector[2:0], 1'b1};
                end else begin
                    patternDetector <= {patternDetector[2:0], 1'b0};
                end
                if (patternDetector == 4'd13) begin // 1101
                    state <= SHIFT;
                    patternDetector <= 4'd0;
                    shiftCounter <= 2'd0;
                end else begin
                    state <= IDLE;
                end
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
            SHIFT: begin
                shift_ena <= 1'b1;
                if (shiftCounter == 2'd3) begin
                    shift_ena <= 1'b0;
                    state <= COUNTING;
                    shiftCounter <= 2'd0;
                end else begin
                    state <= SHIFT;
                    shiftCounter <= shiftCounter + 1;
                end
                counting <= 1'b0;
                done <= 1'b0;
            end
            COUNTING: begin
                counting <= 1'b1;
                shift_ena <= 1'b0;
                if (done_counting) begin
                    state <= DONE;
                end else begin
                    state <= COUNTING;
                end
                done <= 1'b0;
            end
            DONE: begin
                counting <= 1'b0;
                shift_ena <= 1'b0;
                done <= 1'b1;
                if (ack) begin
                    state <= IDLE;
                end else begin
                    state <= DONE;
                end
            end
        endcase
    end
end

endmodule