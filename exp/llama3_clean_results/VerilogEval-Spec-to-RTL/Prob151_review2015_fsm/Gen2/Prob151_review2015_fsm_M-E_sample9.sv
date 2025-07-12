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

reg [3:0] state; // One-hot encoding for states
reg [3:0] pattern; // Register to store the input pattern
reg [1:0] shift_count; // Counter for shifting
reg [3:0] duration; // Register to store the duration

localparam IDLE = 4'b0001;
localparam PATTERN_DETECT = 4'b0010;
localparam SHIFT = 4'b0100;
localparam COUNTING = 4'b1000;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        shift_count <= 2'b00;
        duration <= 4'b0000;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                pattern[3:1] <= pattern[2:0];
                pattern[0] <= data;
                if (pattern == 4'b1101) begin
                    state <= PATTERN_DETECT;
                end
            end
            PATTERN_DETECT: begin
                state <= SHIFT;
            end
            SHIFT: begin
                if (shift_count == 2'b11) begin
                    state <= COUNTING;
                    shift_ena <= 1'b0;
                end else begin
                    shift_count <= shift_count + 1'b1;
                    shift_ena <= 1'b1;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                    state <= COUNTING;
                    counting <= 1'b1;
                end else if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                end else begin
                    state <= COUNTING;
                    counting <= 1'b1;
                    done <= 1'b1;
                end
            end
            default: begin
                state <= IDLE;
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
        endcase
    end
end

endmodule