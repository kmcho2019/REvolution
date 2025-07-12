module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

// Pattern Detection Module
reg [3:0] pattern_reg;
reg pattern_detected;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pattern_reg <= 4'd0;
        pattern_detected <= 1'b0;
    end
    else begin
        pattern_reg <= {pattern_reg[2:0], data};
        if (pattern_reg == 4'b1101) begin
            pattern_detected <= 1'b1;
        end
        else begin
            pattern_detected <= 1'b0;
        end
    end
end

// FSM
reg [2:0] state;
reg [3:0] delay_reg;
reg [19:0] counter;
reg [3:0] remaining_time;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'd0;
        delay_reg <= 4'd0;
        counter <= 20'd0;
        remaining_time <= 4'd0;
        count <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
    end
    else begin
        case (state)
            3'd0: begin // IDLE
                if (pattern_detected) begin
                    state <= 3'd1; // DELAY_SHIFT
                end
            end
            3'd1: begin // DELAY_SHIFT
                if (delay_reg == 4'd0) begin
                    delay_reg <= {data, 3'b0};
                end
                else if (delay_reg == 4'b1000) begin
                    delay_reg <= {delay_reg[2:0], data};
                end
                else if (delay_reg == 4'b1100) begin
                    delay_reg <= {delay_reg[1:0], data};
                end
                else if (delay_reg == 4'b1110) begin
                    delay_reg <= {delay_reg[0], data};
                    state <= 3'd2; // COUNTING
                    counter <= (delay_reg + 1) * 1000 - 1;
                    remaining_time <= delay_reg;
                    counting <= 1'b1;
                end
            end
            3'd2: begin // COUNTING
                if (counter > 20'd0) begin
                    counter <= counter - 1;
                    if (counter % 1000 == 999) begin
                        remaining_time <= remaining_time - 1;
                    end
                end
                else begin
                    state <= 3'd3; // DONE
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            end
            3'd3: begin // DONE
                if (ack) begin
                    state <= 3'd0; // IDLE
                    counter <= 20'd0;
                    delay_reg <= 4'd0;
                    remaining_time <= 4'd0;
                    count <= 4'd0;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

// Output Signal Handling
always @(*) begin
    if (state == 3'd2) begin // COUNTING
        count = remaining_time;
    end
    else begin
        count = 4'bx;
    end
end

endmodule