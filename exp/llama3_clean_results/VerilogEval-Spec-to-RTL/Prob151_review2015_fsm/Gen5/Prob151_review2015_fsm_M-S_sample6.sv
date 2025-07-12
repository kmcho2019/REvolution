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

// Enum for states
enum logic [1:0] {
    IDLE,
    SHIFT,
    COUNTING
} state, next_state;

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
                    state <= SHIFT;
                    shift_count <= 2'b00; // Reset shift count
                end else begin
                    state <= IDLE;
                end
            end
            SHIFT: begin
                shift_count <= shift_count + 1'b1;
                if (shift_count == 2'b11) begin
                    state <= COUNTING;
                end
            end
            COUNTING: begin
                if (done_counting && ack) begin
                    state <= IDLE;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
        shift_ena <= (state == SHIFT) ? 1'b1 : 1'b0;
        counting <= (state == COUNTING) ? 1'b1 : 1'b0;
        done <= (state == COUNTING && done_counting) ? 1'b1 : 1'b0;
    end
end

endmodule