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

reg [2:0] state; // State machine
reg [3:0] pattern; // Register to store the input pattern
reg [1:0] shift_count; // Counter for shifting

localparam IDLE = 3'b000;
localparam PATTERN_DETECTED = 3'b001;
localparam SHIFTING = 3'b010;
localparam COUNTING_STATE = 3'b011;
localparam DONE_STATE = 3'b100;

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
                    state <= PATTERN_DETECTED;
                end
            end
            PATTERN_DETECTED: begin
                state <= SHIFTING;
            end
            SHIFTING: begin
                shift_ena <= 1'b1;
                if (shift_count == 2'b11) begin
                    state <= COUNTING_STATE;
                    shift_ena <= 1'b0;
                end else begin
                    shift_count <= shift_count + 1'b1;
                end
            end
            COUNTING_STATE: begin
                counting <= 1'b1;
                if (done_counting) begin
                    state <= DONE_STATE;
                end
            end
            DONE_STATE: begin
                done <= 1'b1;
                if (ack) begin
                    state <= IDLE;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule