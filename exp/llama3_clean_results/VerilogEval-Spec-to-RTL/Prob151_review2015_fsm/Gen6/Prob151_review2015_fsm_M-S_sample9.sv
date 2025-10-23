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

reg [3:0] pattern_det;
reg [3:0] duration;
reg [2:0] shift_count;
reg [2:0] state;

localparam IDLE = 3'b000;
localparam PATTERN_DETECT = 3'b001;
localparam SHIFT_BITS = 3'b010;
localparam COUNTING = 3'b011;
localparam DONE_STATE = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        pattern_det <= 4'b0000;
        duration <= 4'b0000;
        shift_count <= 3'b000;
        state <= IDLE;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                pattern_det <= {pattern_det[2:0], data};
                if (pattern_det == 4'b1101) begin
                    state <= PATTERN_DETECT;
                end
            end
            PATTERN_DETECT: begin
                state <= SHIFT_BITS;
            end
            SHIFT_BITS: begin
                shift_ena <= 1;
                duration <= {duration[2:0], data};
                shift_count <= shift_count + 1;
                if (shift_count == 3'b100) begin
                    shift_ena <= 0;
                    shift_count <= 3'b000;
                    state <= COUNTING;
                end
            end
            COUNTING: begin
                counting <= 1;
                if (done_counting) begin
                    state <= DONE_STATE;
                end
            end
            DONE_STATE: begin
                counting <= 0;
                done <= 1;
                if (ack) begin
                    done <= 0;
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule