module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

reg [3:0] state;
reg [3:0] shift_cnt;

parameter IDLE = 4'b0000;
parameter SHIFT = 4'b0001;
parameter COUNTING = 4'b0010;
parameter DONE_WAIT = 4'b0011;

reg [3:0] pattern_detector;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_detector <= 4'b0000;
        shift_cnt <= 4'b0000;
    end else begin
        case (state)
            IDLE: begin
                if (pattern_detector == 4'b1101) begin
                    state <= SHIFT;
                    pattern_detector <= 4'b0000;
                end else if (data) begin
                    pattern_detector <= {pattern_detector[2:0], 1'b1};
                end else begin
                    pattern_detector <= {pattern_detector[2:0], 1'b0};
                end
            end
            SHIFT: begin
                if (shift_cnt == 4'b1000) begin
                    state <= COUNTING;
                    shift_cnt <= 4'b0000;
                end else begin
                    shift_cnt <= shift_cnt + 1'b1;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                    state <= DONE_WAIT;
                end
            end
            DONE_WAIT: begin
                if (ack) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

assign shift_ena = (state == SHIFT);
assign counting = (state == COUNTING);
assign done = (state == DONE_WAIT);

endmodule