module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [2:0] state;
reg [2:0] next_state;
reg [3:0] pattern_det;
reg [2:0] shift_count;

localparam IDLE = 3'b000;
localparam PATTERN_DETECT = 3'b001;
localparam SHIFT_BITS = 3'b010;
localparam COUNTING = 3'b011;
localparam DONE_STATE = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        pattern_det <= 4'b0000;
        shift_count <= 3'b000;
    end
    else begin
        case (state)
            IDLE: begin
                pattern_det <= {pattern_det[2:0], data};
                if (pattern_det == 4'b1101) begin
                    next_state <= PATTERN_DETECT;
                end
                else begin
                    next_state <= IDLE;
                end
            end
            PATTERN_DETECT: begin
                next_state <= SHIFT_BITS;
            end
            SHIFT_BITS: begin
                shift_ena <= 1;
                shift_count <= shift_count + 1;
                if (shift_count == 3'b100) begin
                    shift_ena <= 0;
                    shift_count <= 3'b000;
                    next_state <= COUNTING;
                end
                else begin
                    next_state <= SHIFT_BITS;
                end
            end
            COUNTING: begin
                counting <= 1;
                if (done_counting) begin
                    next_state <= DONE_STATE;
                end
                else begin
                    next_state <= COUNTING;
                end
            end
            DONE_STATE: begin
                counting <= 0;
                done <= 1;
                if (ack) begin
                    done <= 0;
                    next_state <= IDLE;
                end
                else begin
                    next_state <= DONE_STATE;
                end
            end
        endcase
        state <= next_state;
    end
end

endmodule