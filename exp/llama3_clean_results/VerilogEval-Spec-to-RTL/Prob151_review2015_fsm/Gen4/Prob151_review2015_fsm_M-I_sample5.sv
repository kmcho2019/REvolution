module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// One-hot encoding for states
localparam IDLE = 4'b0001;
localparam PATTERN_DETECT = 4'b0010;
localparam SHIFT = 4'b0100;
localparam COUNTING = 4'b1000;

reg [3:0] state;
reg [3:0] pattern; // Register to store the input pattern
reg [1:0] shift_count; // Counter for shifting

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        shift_count <= 2'b00;
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
                end else begin
                    state <= IDLE;
                end
            end
            PATTERN_DETECT: begin
                state <= SHIFT;
                shift_count <= 2'b00; // Reset shift count
            end
            SHIFT: begin
                shift_count <= shift_count + 1'b1;
                if (shift_count == 2'b11) begin
                    state <= COUNTING;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                    if (ack) begin
                        state <= IDLE;
                    end
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
        PATTERN_DETECT: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
        SHIFT: begin
            shift_ena = 1'b1;
            counting = 1'b0;
            done = 1'b0;
        end
        COUNTING: begin
            shift_ena = 1'b0;
            counting = 1'b1;
            if (ack) begin
                done = 1'b0;
            end else begin
                done = 1'b1;
            end
        end
        default: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
    endcase
end

endmodule