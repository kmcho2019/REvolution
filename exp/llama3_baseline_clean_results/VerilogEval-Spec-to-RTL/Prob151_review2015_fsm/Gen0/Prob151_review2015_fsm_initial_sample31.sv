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

reg [3:0] shift_count;
reg [3:0] state;
localparam IDLE = 4'b0000;
localparam DETECT = 4'b0001;
localparam SHIFT = 4'b0010;
localparam COUNT = 4'b0011;
localparam DONE = 4'b0100;

reg [3:0] pattern_det;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
        shift_count <= 4'b0000;
        pattern_det <= 4'b0000;
    end else begin
        case (state)
            IDLE: begin
                if (pattern_det == 4'b1101) begin
                    state <= DETECT;
                    pattern_det <= 4'b0000;
                end else begin
                    if (data) begin
                        pattern_det <= {pattern_det[2:0], 1'b1};
                    end else begin
                        pattern_det <= {pattern_det[2:0], 1'b0};
                    end
                end
            end
            DETECT: begin
                state <= SHIFT;
            end
            SHIFT: begin
                shift_ena <= 1'b1;
                shift_count <= shift_count + 1;
                if (shift_count == 4'b0100) begin
                    shift_ena <= 1'b0;
                    state <= COUNT;
                    shift_count <= 4'b0000;
                end
            end
            COUNT: begin
                counting <= 1'b1;
                if (done_counting) begin
                    state <= DONE;
                    counting <= 1'b0;
                end
            end
            DONE: begin
                done <= 1'b1;
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule