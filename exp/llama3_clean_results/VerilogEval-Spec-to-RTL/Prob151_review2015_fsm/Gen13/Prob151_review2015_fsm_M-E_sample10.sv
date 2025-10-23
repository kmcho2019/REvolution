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

// Control unit signals
reg [1:0] state;
reg start_timer;
reg shift_done;
reg count_done;

// Data processing unit signals
reg [3:0] pattern;
reg [1:0] shift_cnt;
reg [3:0] delay;

// Pipeline stages
reg [3:0] pattern_stage1;
reg [3:0] pattern_stage2;
reg [1:0] shift_cnt_stage3;
reg done_stage4;

// Control unit
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        start_timer <= 0;
        shift_done <= 0;
        count_done <= 0;
    end
    else begin
        case (state)
            2'b00: begin
                if (pattern == 4'b1101) begin
                    start_timer <= 1;
                    state <= 2'b01;
                end
            end
            2'b01: begin
                if (shift_cnt == 4) begin
                    shift_done <= 1;
                    state <= 2'b10;
                end
            end
            2'b10: begin
                if (done_counting) begin
                    count_done <= 1;
                    state <= 2'b11;
                end
            end
            2'b11: begin
                if (ack) begin
                    state <= 2'b00;
                end
            end
        endcase
    end
end

// Data processing unit (pipeline)
always @(posedge clk) begin
    // Stage 1: Pattern detection
    pattern_stage1 <= {pattern[2:0], data};
    
    // Stage 2: Pattern detection (2nd stage)
    pattern_stage2 <= pattern_stage1;
    
    // Stage 3: Shift count increment
    if (start_timer) begin
        shift_cnt_stage3 <= shift_cnt + 1;
    end
    else begin
        shift_cnt_stage3 <= shift_cnt;
    end
    
    // Stage 4: Done signal generation
    if (count_done) begin
        done_stage4 <= 1;
    end
    else begin
        done_stage4 <= 0;
    end
end

// Output logic
assign shift_ena = (state == 2'b01) && (shift_cnt < 4);
assign counting = (state == 2'b10) && (done_counting == 0);
assign done = done_stage4;

endmodule