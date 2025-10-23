module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

reg [1:0] state; // Current state
reg [1:0] nextState; // Next state
reg [3:0] shift_cnt; // Counter for number of bits shifted
reg [3:0] pattern_cnt; // Counter for pattern detection
reg [3:0] pattern; // Detected pattern

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        shift_cnt <= 4'b0000;
        pattern_cnt <= 4'b0000;
        pattern <= 4'b0000;
    end else begin
        state <= nextState;
        shift_cnt <= shift_cnt + 1;
        pattern_cnt <= pattern_cnt + 1;
        pattern <= {pattern[2:0], data};
    end
end

always @(*) begin
    case (state)
        2'b00: begin // IDLE state
            if (pattern == 4'b1101) begin
                nextState = 2'b01;
            end else begin
                nextState = 2'b00;
            end
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
        2'b01: begin // SHIFT state
            if (shift_cnt == 4) begin
                nextState = 2'b10;
            end else begin
                nextState = 2'b01;
            end
            shift_ena = 1'b1;
            counting = 1'b0;
            done = 1'b0;
        end
        2'b10: begin // COUNTING state
            if (done_counting) begin
                nextState = 2'b11;
            end else begin
                nextState = 2'b10;
            end
            shift_ena = 1'b0;
            counting = 1'b1;
            done = 1'b0;
        end
        2'b11: begin // DONE state
            if (ack) begin
                nextState = 2'b00;
            end else begin
                nextState = 2'b11;
            end
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b1;
        end
        default: begin
            nextState = 2'b00;
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
    endcase
end

endmodule