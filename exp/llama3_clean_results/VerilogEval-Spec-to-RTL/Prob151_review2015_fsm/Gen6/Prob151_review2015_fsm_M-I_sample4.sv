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
reg [3:0] shift_data; // Register to store the shifted data

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        shift_count <= 2'b00;
        shift_data <= 4'b0000;
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
                shift_count <= 2'b00; // Reset shift count
            end
            SHIFT: begin
                shift_data[3:1] <= shift_data[2:0];
                shift_data[0] <= data;
                shift_count <= shift_count + 1'b1;
                if (shift_count == 2'b11) begin // Shifted 4 times
                    state <= COUNTING;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                    if (ack) begin
                        state <= IDLE; // Reset state on ack
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
            done = done_counting; // Assert done after counting is done
        end
        default: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
    endcase
end

endmodule